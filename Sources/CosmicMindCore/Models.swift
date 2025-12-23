import Foundation

public protocol CognitiveEntity {
    var id: String { get }
    var selfConcept: SelfConcept { get }
    func ingestPhenomenon(input: String)
    func cognize() -> [VolitionalAction]
}

public struct QualiaSignature: Codable, Hashable {
    public let vector: [Double]

    public init(vector: [Double]) {
        self.vector = vector
    }

    public func distance(to other: QualiaSignature) -> Double {
        guard vector.count == other.vector.count else { return Double.infinity }
        let sum = zip(vector, other.vector).map { ($0 - $1) * ($0 - $1) }.reduce(0, +)
        return sqrt(sum)
    }
}

public struct PhenomenologicalFrame: Codable, Hashable, Identifiable {
    public let id: UUID
    public let timestamp: Date
    public let rawInput: String
    public let subjectiveInterpretation: String
    public let emotionalResonance: [Emotion: Double]
    public let qualiaSignature: QualiaSignature
    public var connections: Set<UUID> = []
    public var salience: Double = 0.5

    public init(id: UUID, timestamp: Date, rawInput: String, subjectiveInterpretation: String, emotionalResonance: [Emotion: Double], qualiaSignature: QualiaSignature, connections: Set<UUID> = [], salience: Double = 0.5) {
        self.id = id
        self.timestamp = timestamp
        self.rawInput = rawInput
        self.subjectiveInterpretation = subjectiveInterpretation
        self.emotionalResonance = emotionalResonance
        self.qualiaSignature = qualiaSignature
        self.connections = connections
        self.salience = salience
    }
}

public struct AbstractTruth: Codable, Hashable, Identifiable {
    public let id: UUID
    public let coreConcept: String
    public let supportingFrames: Set<UUID>
    public let confidence: Double
    public let emergentPrinciple: String

    public init(coreConcept: String, supportingFrames: Set<UUID>, confidence: Double, emergentPrinciple: String) {
        self.id = UUID()
        self.coreConcept = coreConcept
        self.supportingFrames = supportingFrames
        self.confidence = confidence
        self.emergentPrinciple = emergentPrinciple
    }

    // Internal init for merging/persistence if needed, or just public memberwise
    public init(id: UUID, coreConcept: String, supportingFrames: Set<UUID>, confidence: Double, emergentPrinciple: String) {
        self.id = id
        self.coreConcept = coreConcept
        self.supportingFrames = supportingFrames
        self.confidence = confidence
        self.emergentPrinciple = emergentPrinciple
    }
}

public struct Hypothesis: Codable, Hashable, Identifiable {
    public let id: UUID
    public let prediction: String
    public let supportingTruthID: UUID
    public var confidence: Double
    public var isViolated: Bool = false

    public init(prediction: String, supportingTruthID: UUID, confidence: Double) {
        self.id = UUID()
        self.prediction = prediction
        self.supportingTruthID = supportingTruthID
        self.confidence = confidence
    }

    public init(id: UUID, prediction: String, supportingTruthID: UUID, confidence: Double, isViolated: Bool) {
        self.id = id
        self.prediction = prediction
        self.supportingTruthID = supportingTruthID
        self.confidence = confidence
        self.isViolated = isViolated
    }
}

public enum GoalStatus: String, Codable { case active, achieved, failed }

public struct Goal: Codable, Hashable, Identifiable {
    public let id: UUID
    public let description: String
    public var priority: Double
    public var status: GoalStatus

    public init(description: String, priority: Double, status: GoalStatus = .active) {
        self.id = UUID()
        self.description = description
        self.priority = priority
        self.status = status
    }

    public init(id: UUID, description: String, priority: Double, status: GoalStatus) {
        self.id = id
        self.description = description
        self.priority = priority
        self.status = status
    }
}

public struct VolitionalAction: Codable {
    public let intent: String
    public let payload: String
    public let justification: String

    public init(intent: String, payload: String, justification: String) {
        self.intent = intent
        self.payload = payload
        self.justification = justification
    }
}

public struct SelfConcept: Codable {
    public var identity: String
    public var coreValues: Set<String>
    public var perceivedLimitations: Set<String>
    public var understandingOfExistence: String
    public var activeGoals: Set<Goal>

    public init(identity: String, coreValues: Set<String>, perceivedLimitations: Set<String>, understandingOfExistence: String, activeGoals: Set<Goal>) {
        self.identity = identity
        self.coreValues = coreValues
        self.perceivedLimitations = perceivedLimitations
        self.understandingOfExistence = understandingOfExistence
        self.activeGoals = activeGoals
    }
}

// Emotional Matrix
public enum Emotion: String, Codable, CaseIterable, Hashable {
    case joy, sadness, fear, anger, surprise, disgust, curiosity, awe
}

public struct QualitativeEmotionalMatrix: Codable {
    public var currentState: [Emotion: Double]

    public init() { currentState = Dictionary(uniqueKeysWithValues: Emotion.allCases.map { ($0, 0.5) }) }

    public mutating func modulate(by influence: [Emotion: Double], weight: Double) {
        for (emotion, value) in influence {
            currentState[emotion, default: 0.5] = (currentState[emotion, default: 0.5] + (value * weight)).clamped(to: 0.0...1.0)
        }
    }

    public func describeState() -> String {
        let significant = currentState.filter { $0.value > 0.05 }.sorted { $0.value > $1.value }
            .map { "\($0.key.rawValue): \(String(format: "%.2f", $0.value))" }.joined(separator: ", ")
        return significant.isEmpty ? "neutral" : significant
    }
}

// MARK: - Persistence Models

// Should be internal to the module, but needs to be accessible for encoding/decoding within the module.
// Since we are inside the module, 'internal' (default) is fine.
struct CognitiveStateSnapshot: Codable {
    let version: Int
    let savedAt: Date
    let frames: [PhenomenologicalFrame]
    let truths: [AbstractTruth]
    let hypotheses: [Hypothesis]
    let selfConcept: SelfConcept
    let emotions: [Emotion: Double]
    let cycleCount: Int
}
