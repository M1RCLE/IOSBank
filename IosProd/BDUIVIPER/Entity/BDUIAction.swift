public struct BDUIAction: Decodable {
    public let type: ActionType
    public let payload: [String: AnyCodable]?
    
    public init(type: ActionType, payload: [String: AnyCodable]? = nil) {
        self.type = type
        self.payload = payload
    }
}

public enum ActionType: String, Decodable {
    case navigate
    case reload
    case dismiss
    case custom
}
