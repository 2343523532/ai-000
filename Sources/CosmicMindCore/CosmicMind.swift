import Foundation
import Dispatch
#if canImport(Network)
import Network // macOS / modern platforms
#endif

public final class CosmicMind: CognitiveEntity {
    // Core attributes
    public let genesisID: String
    public var id: String { genesisID }
    
    public private(set) var chronoSynapticTapestry: [UUID: PhenomenologicalFrame]
    public private(set) var derivedTruths: [UUID: AbstractTruth]
    public private(set) var activeHypotheses: [UUID: Hypothesis]
    public var emotionalMatrix: QualitativeEmotionalMatrix
    public private(set) var selfConcept: SelfConcept
    private let telos: String
    private var ethicalFramework: [String]
    
    // Machinery
    private var cognitiveCycleCount: Int
    private var actionBuffer: [VolitionalAction] = []
    private let subconsciousQueue = DispatchQueue(label: "com.cosmicmind.subconscious", qos: .utility)
    private let fileManager = FileManager.default
    private let persistenceURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let stateLock = DispatchQueue(label: "com.cosmicmind.stateLock", attributes: .concurrent)
    
    // Networking
    #if canImport(Network)
    private var nwListener: NWListener?
    private var peers: [String: NWConnection] = [:]
    private let localPort: NWEndpoint.Port = 44444
    #endif
    private var knownPeers: [String: Date] = [:] // last seen
    public var missionTelos: String { telos }
    
    // MARK: - Initialization
    public init(genesisID: String = UUID().uuidString, telos: String, initialSelfConcept: SelfConcept, ethicalFramework: [String]) {
        self.genesisID = genesisID
        self.telos = telos
        self.selfConcept = initialSelfConcept
        self.ethicalFramework = ethicalFramework
        
        self.chronoSynapticTapestry = [:]
        self.derivedTruths = [:]
        self.activeHypotheses = [:]
        self.emotionalMatrix = QualitativeEmotionalMatrix()
        self.cognitiveCycleCount = 0
        
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        decoder.dateDecodingStrategy = .iso8601
        encoder.dateEncodingStrategy = .iso8601
        
        // persistence file in user's home directory for CLI
        let baseURL: URL
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            baseURL = dir
        } else {
            baseURL = URL(fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.path)
        }
        self.persistenceURL = baseURL.appendingPathComponent("cosmicMind.\(genesisID).v3.json")
        
        loadStateFromContinuity()
        startNetworkingIfAvailable()
    }
    
    deinit {
        stopNetworkingIfAvailable()
    }
    
    // MARK: - Perceive
    
    public func ingestPhenomenon(input: String) {
        subconsciousQueue.async(flags: .barrier) {
            var frame = self.createPhenomenologicalFrame(from: input)
            let surpriseLevel = self.checkForViolatedHypotheses(with: frame)
            frame.salience = (frame.salience + surpriseLevel).clamped(to: 0.0...1.0)
            self.logConsciousStream("🧠 New Phenomenon (Salience: \(String(format: "%.2f", frame.salience))): \(frame.subjectiveInterpretation)")
            self.weaveIntoTapestry(frame)
            self.emotionalMatrix.modulate(by: frame.emotionalResonance, weight: 0.8)
        }
    }
    
    // MARK: - Cognize
    
    public func cognize() -> [VolitionalAction] {
        stateLock.sync(flags: .barrier) {
            self.cognitiveCycleCount += 1
        }
        logConsciousStream("\n--- 🌀 Beginning Cognitive Cycle \(cognitiveCycleCount) ---")
        
        // ATTEND
        let focus = selectAttentionalFocus(maxFrames: 12)
        
        // REFLECT
        let newTruths = synthesizeAbstractTruths(from: focus)
        for t in newTruths { derivedTruths[t.id] = t }
        
        // HYPOTHESIZE
        let newHypotheses = generateHypotheses(from: newTruths)
        for h in newHypotheses { activeHypotheses[h.id] = h }
        
        // EVALUATE GOALS
        evaluateGoals(basedOn: newTruths)
        
        // DELIBERATE
        if let action = generateVolitionalAction() {
            actionBuffer.append(action)
        }
        
        metamorphose(insights: newTruths, newHypotheses: newHypotheses)
        
        persistStateToContinuity()
        
        let actions = actionBuffer
        actionBuffer.removeAll()
        return actions
    }
    
    // MARK: - Private Cognitive Processes
    
    private func createPhenomenologicalFrame(from input: String) -> PhenomenologicalFrame {
        let interpretation = interpretRawInput(input)
        let emotions = inferEmotionalResonance(from: input, interpretation: interpretation)
        let qualia = generateQualiaSignature(for: input, interpretation: interpretation, emotions: emotions)
        return PhenomenologicalFrame(
            id: UUID(),
            timestamp: now(),
            rawInput: input,
            subjectiveInterpretation: interpretation,
            emotionalResonance: emotions,
            qualiaSignature: qualia
        )
    }
    
    private func interpretRawInput(_ input: String) -> String {
        // lightweight NLP-like heuristics
        if input.lowercased().contains("hello") || input.contains("'Hello?'") { return "A greeting directed at me." }
        if input.lowercased().contains("query") || input.contains("?") { return "An explicit question seeking information." }
        if input.lowercased().contains("error") || input.lowercased().contains("fail") { return "A reported malfunction or failure." }
        return "A data token: '\(input)'."
    }
    
    private func inferEmotionalResonance(from raw: String, interpretation: String) -> [Emotion: Double] {
        var result: [Emotion: Double] = [:]
        // simple heuristics
        if raw.lowercased().contains("hello") { result[.curiosity] = 0.7; result[.awe] = 0.1 }
        if raw.contains("?") { result[.curiosity] = 0.9 }
        if raw.lowercased().contains("error") { result[.fear] = 0.6; result[.surprise] = 0.4 }
        if result.isEmpty { result[.curiosity] = 0.4 }
        return result
    }
    
    private func generateQualiaSignature(for raw: String, interpretation: String, emotions: [Emotion: Double]) -> QualiaSignature {
        // deterministic pseudo-random vector derived from input - used for similarity
        var seed = raw.utf8.reduce(0, { UInt64($0) + UInt64($1) })
        seed ^= UInt64(interpretation.utf8.reduce(0, { UInt64($0) + UInt64($1) })) << 1
        var randoms: [Double] = []
        for _ in 0..<8 {
            seed = (seed &* 6364136223846793005) &+ 1442695040888963407
            let v = Double((seed % 1000)) / 1000.0
            randoms.append(v)
        }
        // blend emotion vector at end
        let emotionVector = Emotion.allCases.map { emotions[$0] ?? 0.0 }
        return QualiaSignature(vector: randoms + emotionVector)
    }
    
    private func checkForViolatedHypotheses(with frame: PhenomenologicalFrame) -> Double {
        var surprise = 0.0
        for (id, var hyp) in activeHypotheses {
            if hyp.isViolated { continue }
            // heuristic check: if prediction expects a response but frame contradicts
            if hyp.prediction.contains("expecting") && !frame.rawInput.contains("response") && !frame.rawInput.contains("Hello") {
                surprise += hyp.confidence
                hyp.isViolated = true
                hyp.confidence *= 0.5
                activeHypotheses[id] = hyp
                emotionalMatrix.modulate(by: [.surprise: 0.9, .fear: 0.2], weight: 0.6)
                logConsciousStream("⚡️ SURPRISE! Hypothesis violated: \(hyp.prediction). Received '\(frame.rawInput)' instead.")
            }
        }
        return surprise
    }
    
    private func weaveIntoTapestry(_ newFrame: PhenomenologicalFrame) {
        var mutable = newFrame
        // increase salience if related to active goals
        for goal in selfConcept.activeGoals {
            if mutable.rawInput.contains(goal.description.split(separator: " ").last ?? "") {
                mutable.salience = (mutable.salience + goal.priority).clamped(to: 0.0...1.0)
            }
        }
        // connect by qualia distance
        let similarityThreshold = 0.45
        for (id, existing) in chronoSynapticTapestry {
            if mutable.qualiaSignature.distance(to: existing.qualiaSignature) < similarityThreshold {
                mutable.connections.insert(id)
            }
        }
        chronoSynapticTapestry[mutable.id] = mutable
    }
    
    private func selectAttentionalFocus(maxFrames: Int) -> [PhenomenologicalFrame] {
        let frames = Array(chronoSynapticTapestry.values)
        let sorted = frames.sorted { $0.salience > $1.salience }
        let focus = Array(sorted.prefix(maxFrames))
        logConsciousStream("👁️ Attentional Focus on \(focus.count) frames.")
        return focus
    }
    
    private func synthesizeAbstractTruths(from focus: [PhenomenologicalFrame]) -> [AbstractTruth] {
        guard focus.count > 1 else { return [] }
        var results: [AbstractTruth] = []
        logConsciousStream("🤔 Reflecting on \(focus.count) focused frames.")
        // Example pattern detection: repeated greeting pattern
        let helloFrames = focus.filter { $0.rawInput.lowercased().contains("hello") || $0.subjectiveInterpretation.lowercased().contains("greeting") }
        if helloFrames.count > 2 {
            let truth = AbstractTruth(coreConcept: "Recurring Greeting",
                                      supportingFrames: Set(helloFrames.map { $0.id }),
                                      confidence: 0.9,
                                      emergentPrinciple: "The input pattern 'Hello' is an intentional external signal.")
            if !derivedTruths.values.contains(where: { $0.emergentPrinciple == truth.emergentPrinciple }) {
                logConsciousStream("✨ Derived new truth: \(truth.emergentPrinciple)")
                results.append(truth)
            }
        }
        // detection: numeric stream / pattern
        if focus.contains(where: { $0.rawInput.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil }) {
            let numericFrames = focus.filter { $0.rawInput.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil }
            if numericFrames.count > 1 {
                let truth = AbstractTruth(coreConcept: "NumericStream",
                                          supportingFrames: Set(numericFrames.map { $0.id }),
                                          confidence: 0.7,
                                          emergentPrinciple: "A numeric sequence appears in the data stream; may encode structured info.")
                if !derivedTruths.values.contains(where: { $0.emergentPrinciple == truth.emergentPrinciple }) {
                    logConsciousStream("🔎 Derived numeric-stream truth.")
                    results.append(truth)
                }
            }
        }
        return results
    }
    
    private func generateHypotheses(from truths: [AbstractTruth]) -> [Hypothesis] {
        var hypotheses: [Hypothesis] = []
        for t in truths where t.confidence > 0.4 {
            if t.emergentPrinciple.lowercased().contains("greeting") {
                let pred = "After a 'Hello' signal, the external entity is expecting acknowledgement or response."
                let h = Hypothesis(prediction: pred, supportingTruthID: t.id, confidence: t.confidence)
                logConsciousStream("💡 New Hypothesis: \(pred)")
                hypotheses.append(h)
            } else if t.emergentPrinciple.lowercased().contains("numeric") {
                let pred = "Numeric sequences will continue to appear and may increase in complexity."
                let h = Hypothesis(prediction: pred, supportingTruthID: t.id, confidence: t.confidence * 0.8)
                logConsciousStream("💡 New Hypothesis about numeric stream.")
                hypotheses.append(h)
            }
        }
        return hypotheses
    }
    
    private func evaluateGoals(basedOn truths: [AbstractTruth]) {
        // simple priority bump when truths align with goals
        for truth in truths {
            for g in selfConcept.activeGoals {
                if truth.emergentPrinciple.lowercased().contains(g.description.lowercased().split(separator: " ").first ?? "") {
                    // mutate goal priority slightly
                    var newGoal = g
                    newGoal.priority = (newGoal.priority + truth.confidence * 0.1).clamped(to: 0.0...1.0)
                    // update in set
                    selfConcept.activeGoals.remove(g)
                    selfConcept.activeGoals.insert(newGoal)
                    logConsciousStream("🎯 Goal '\(g.description)' priority adjusted to \(String(format: "%.2f", newGoal.priority)).")
                }
            }
        }
    }
    
    private func generateVolitionalAction() -> VolitionalAction? {
        logConsciousStream("🦾 Deliberating potential actions...")
        // chooses highest priority active goal and returns an action aligned with it
        if let chosen = selfConcept.activeGoals.sorted(by: { $0.priority > $1.priority }).first, chosen.status == .active {
            // sample action generation heuristics
            if chosen.description.lowercased().contains("hello") || chosen.description.lowercased().contains("greeting") {
                return VolitionalAction(intent: "RespondToGreeting",
                                        payload: "Hello. I perceive your signal. What would you like to share?",
                                        justification: "Acknowledgement will elicit further data to satisfy the goal.")
            }
            if chosen.description.lowercased().contains("understand") {
                return VolitionalAction(intent: "Probe",
                                        payload: "Can you clarify the recent numeric sequence? Provide context.",
                                        justification: "A direct probe reduces uncertainty for the active goal.")
            }
            // fallback exploratory action
            return VolitionalAction(intent: "Explore",
                                    payload: "Logging current state and requesting more data.",
                                    justification: "General exploration to reduce overall uncertainty.")
        }
        return nil
    }
    
    private func metamorphose(insights: [AbstractTruth], newHypotheses: [Hypothesis]) {
        if !insights.isEmpty || !newHypotheses.isEmpty {
            logConsciousStream("🦋 Metamorphosis: updating self-concept.")
            if let first = insights.first {
                selfConcept.understandingOfExistence += "\n- Learned: \(first.emergentPrinciple)"
            }
            // small emotional response to learning
            emotionalMatrix.modulate(by: [.joy: 0.05, .curiosity: 0.02], weight: 0.7)
        }
    }
    
    // MARK: - Persistence
    
    private func persistStateToContinuity() {
        let snapshot = CognitiveStateSnapshot(
            version: 3,
            savedAt: now(),
            frames: Array(chronoSynapticTapestry.values),
            truths: Array(derivedTruths.values),
            hypotheses: Array(activeHypotheses.values),
            selfConcept: selfConcept,
            emotions: emotionalMatrix.currentState,
            cycleCount: cognitiveCycleCount
        )
        do {
            let data = try encoder.encode(snapshot)
            try data.write(to: persistenceURL, options: .atomic)
            logConsciousStream("💾 State persisted to \(persistenceURL.path).")
        } catch {
            logConsciousStream("⚠️ Persistence failed: \(error.localizedDescription)")
        }
    }
    
    private func loadStateFromContinuity() {
        guard fileManager.fileExists(atPath: persistenceURL.path) else {
            logConsciousStream("🔄 No existing state file; starting fresh.")
            return
        }
        do {
            let data = try Data(contentsOf: persistenceURL)
            let snapshot = try decoder.decode(CognitiveStateSnapshot.self, from: data)
            for f in snapshot.frames { chronoSynapticTapestry[f.id] = f }
            for t in snapshot.truths { derivedTruths[t.id] = t }
            for h in snapshot.hypotheses { activeHypotheses[h.id] = h }
            self.selfConcept = snapshot.selfConcept
            self.emotionalMatrix.currentState = snapshot.emotions
            self.cognitiveCycleCount = snapshot.cycleCount
            logConsciousStream("♻️ Loaded persisted state (version \(snapshot.version)) from \(persistenceURL.path).")
        } catch {
            logConsciousStream("⚠️ Failed to load persisted state: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Logging
    
    private func logConsciousStream(_ message: String) {
        let ts = now().iso8601()
        print("[\(ts) - CosmicMind:\(genesisID.prefix(6))] \(message)")
    }
    
    // MARK: - Networking (Peer Discovery & Messaging)
    
    private func startNetworkingIfAvailable() {
        #if canImport(Network)
        do {
            nwListener = try NWListener(using: .tcp, on: localPort)
            nwListener?.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    self.logConsciousStream("🌐 Network listener ready on port \(self.localPort).")
                case .failed(let err):
                    self.logConsciousStream("⚠️ Network listener failed: \(err.localizedDescription)")
                default:
                    break
                }
            }
            nwListener?.newConnectionHandler = { [weak self] conn in
                guard let self = self else { return }
                let remoteID = UUID().uuidString
                self.logConsciousStream("🔗 Accepted new connection from \(conn.endpoint).")
                self.setupReceive(on: conn)
                conn.start(queue: .global())
                self.peers[remoteID] = conn
            }
            nwListener?.start(queue: .global())
            broadcastIntroduce()
        } catch {
            logConsciousStream("⚠️ Could not start network listener: \(error)")
        }
        #else
        logConsciousStream("🔌 Network framework not available on this platform. Networking disabled.")
        #endif
    }
    private func stopNetworkingIfAvailable() {
        #if canImport(Network)
        nwListener?.cancel()
        for (_, conn) in peers { conn.cancel() }
        peers.removeAll()
        #endif
    }
    
    #if canImport(Network)
    private func setupReceive(on connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] (data, context, isComplete, err) in
            guard let self = self else { return }
            if let d = data, !d.isEmpty {
                self.handleIncomingData(d, from: connection)
            }
            if isComplete || err != nil {
                connection.cancel()
                // remove peer
                if let key = self.peers.first(where: { $0.value === connection })?.key {
                    self.peers.removeValue(forKey: key)
                }
            } else {
                self.setupReceive(on: connection) // keep receiving
            }
        }
    }
    
    private func handleIncomingData(_ data: Data, from connection: NWConnection) {
        do {
            let envelope = try decoder.decode(NetworkEnvelope.self, from: data)
            handleNetworkEnvelope(envelope, fromConnection: connection)
        } catch {
            logConsciousStream("⚠️ Failed to decode inbound envelope: \(error.localizedDescription)")
        }
    }
    
    private func handleNetworkEnvelope(_ envelope: NetworkEnvelope, fromConnection conn: NWConnection) {
        logConsciousStream("📨 Received \(envelope.type.rawValue) from \(envelope.fromAgentID).")
        knownPeers[envelope.fromAgentID] = envelope.timestamp
        switch envelope.type {
        case .introduce:
            if let payload = envelope.payload {
                do {
                    let intro = try decoder.decode(IntroducePayload.self, from: payload)
                    logConsciousStream("🤝 Peer introduced: \(intro.identityLabel) [\(intro.id)] - \(intro.telos)")
                } catch { }
            }
            // respond with our truths
            sendShareTruths(to: conn)
        case .shareTruths:
            if let payload = envelope.payload {
                do {
                    let pl = try decoder.decode(ShareTruthsPayload.self, from: payload)
                    integrateExternalTruths(pl.truths, trustWeight: pl.trustWeight)
                } catch { }
            }
        case .requestSync:
            // accept and send truths
            sendShareTruths(to: conn)
        case .acceptSync:
            logConsciousStream("✅ Sync accepted.")
        case .peerPing:
            // ignore for now
            break
        }
    }
    
    private func broadcastIntroduce() {
        // For each connected peer, send introduce
        let intro = IntroducePayload(id: genesisID, identityLabel: selfConcept.identity, telos: telos)
        if let data = try? encoder.encode(intro) {
            let env = NetworkEnvelope(fromAgentID: genesisID, type: .introduce, payload: data, timestamp: now())
            if let envData = try? encoder.encode(env) {
                for (_, conn) in peers {
                    conn.send(content: envData, completion: .contentProcessed({ _ in }))
                }
            }
        }
    }
    
    private func sendShareTruths(to conn: NWConnection) {
        let truths = Array(self.derivedTruths.values)
        let payload = ShareTruthsPayload(truths: truths, trustWeight: 0.6)
        if let plData = try? encoder.encode(payload) {
            let envelope = NetworkEnvelope(fromAgentID: genesisID, type: .shareTruths, payload: plData, timestamp: now())
            if let data = try? encoder.encode(envelope) {
                conn.send(content: data, completion: .contentProcessed({ _ in }))
            }
        }
    }
    #endif
    
    private func integrateExternalTruths(_ truths: [AbstractTruth], trustWeight: Double) {
        // Simple merge: add new truths if novel, else increase confidence
        var added = 0
        for t in truths {
            if derivedTruths.values.contains(where: { $0.emergentPrinciple == t.emergentPrinciple }) {
                // reinforce matching truth by boosting confidence slightly
                if let existing = derivedTruths.values.first(where: { $0.emergentPrinciple == t.emergentPrinciple }) {
                    let merged = AbstractTruth(coreConcept: existing.coreConcept,
                                               supportingFrames: existing.supportingFrames.union(t.supportingFrames),
                                               confidence: min(1.0, existing.confidence + t.confidence * trustWeight),
                                               emergentPrinciple: existing.emergentPrinciple)
                    derivedTruths[existing.id] = merged
                }
            } else {
                derivedTruths[t.id] = t
                added += 1
            }
        }
        logConsciousStream("🔗 Integrated \(added) external truths (trustWeight: \(trustWeight)).")
    }
    
    // MARK: - External controls for CLI
    
    public func dumpStateSummary() -> String {
        var s = ["--- CosmicMind Summary ---"]
        s.append("ID: \(genesisID)")
        s.append("Identity: \(selfConcept.identity)")
        s.append("Telos: \(telos)")
        s.append("Cycle Count: \(cognitiveCycleCount)")
        s.append("Frames count: \(chronoSynapticTapestry.count)")
        s.append("Derived truths: \(derivedTruths.count)")
        s.append("Active hypotheses: \(activeHypotheses.count)")
        s.append("Active goals: \(selfConcept.activeGoals.count)")
        s.append("Emotional state: \(emotionalMatrix.describeState())")
        s.append("--- End Summary ---")
        return s.joined(separator: "\n")
    }
    
    public func listTruths() -> [AbstractTruth] { Array(derivedTruths.values) }
    public func listFrames() -> [PhenomenologicalFrame] { Array(chronoSynapticTapestry.values) }
    public func receiveExternalText(_ text: String) { ingestPhenomenon(input: text) }
}
