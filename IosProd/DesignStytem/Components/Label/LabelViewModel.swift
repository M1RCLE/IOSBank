import UIKit

public struct LabelViewModel {
    public let text: String
    public let style: LabelStyle
    public let color: UIColor?
    public let alignment: NSTextAlignment
    
    public init(
        text: String,
        style: LabelStyle = .body,
        color: UIColor? = nil,
        alignment: NSTextAlignment = .natural
    ) {
        self.text = text
        self.style = style
        self.color = color
        self.alignment = alignment
    }
}
