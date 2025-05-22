public struct ElementStyles: Decodable {
    public let backgroundColor: String?
    public let cornerRadius: String?
    public let padding: PaddingStyle?
    
    public init(backgroundColor: String? = nil, cornerRadius: String? = nil, padding: PaddingStyle? = nil) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
}
