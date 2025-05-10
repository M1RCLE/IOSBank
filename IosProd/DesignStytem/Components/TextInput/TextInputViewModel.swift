import UIKit

public struct TextInputViewModel {
    public let placeholder: String?
    public let text: String?
    public let style: TextInputStyle
    public let isSecure: Bool
    public let leftIcon: UIImage?
    public let rightIcon: UIImage?
    public let onTextChange: ((String) -> Void)?
    
    public init(
        placeholder: String? = nil,
        text: String? = nil,
        style: TextInputStyle = .standard,
        isSecure: Bool = false,
        leftIcon: UIImage? = nil,
        rightIcon: UIImage? = nil,
        onTextChange: ((String) -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self.text = text
        self.style = style
        self.isSecure = isSecure
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.onTextChange = onTextChange
    }
}
