public struct BDUIElement: Decodable {
    public let type: ElementType
    public let id: String?
    public let styles: ElementStyles?
    public let content: [String: AnyCodable]?
    public let subviews: [BDUIElement]?
    public let actions: [String: BDUIAction]?
    
    private enum CodingKeys: String, CodingKey {
        case type, id, styles, content, subviews, actions
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(ElementType.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        styles = try container.decodeIfPresent(ElementStyles.self, forKey: .styles)
        content = try container.decodeIfPresent([String: AnyCodable].self, forKey: .content)
        subviews = try container.decodeIfPresent([BDUIElement].self, forKey: .subviews)
        actions = try container.decodeIfPresent([String: BDUIAction].self, forKey: .actions)
    }
}
