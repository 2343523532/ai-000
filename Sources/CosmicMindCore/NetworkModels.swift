import Foundation

public enum NetworkMessageType: String, Codable {
    case introduce, shareTruths, requestSync, acceptSync, peerPing
}

public struct NetworkEnvelope: Codable {
    public let fromAgentID: String
    public let type: NetworkMessageType
    public let payload: Data? // JSON encoded payload
    public let timestamp: Date

    public init(fromAgentID: String, type: NetworkMessageType, payload: Data?, timestamp: Date) {
        self.fromAgentID = fromAgentID
        self.type = type
        self.payload = payload
        self.timestamp = timestamp
    }
}

// Payload shapes for specific messages
public struct IntroducePayload: Codable {
    public let id: String
    public let identityLabel: String
    public let telos: String

    public init(id: String, identityLabel: String, telos: String) {
        self.id = id
        self.identityLabel = identityLabel
        self.telos = telos
    }
}

public struct ShareTruthsPayload: Codable {
    public let truths: [AbstractTruth]
    public let trustWeight: Double

    public init(truths: [AbstractTruth], trustWeight: Double) {
        self.truths = truths
        self.trustWeight = trustWeight
    }
}

public struct RequestSyncPayload: Codable {
    public let since: Date?

    public init(since: Date?) {
        self.since = since
    }
}
