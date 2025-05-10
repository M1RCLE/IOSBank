import UIKit

public struct ButtonViewModel {
    public let title: String
    public let style: ButtonStyle
    public let icon: UIImage?
    public let isEnabled: Bool
    public let action: (() -> Void)?
    
    public init(
        title: String,
        style: ButtonStyle = .primary,
        icon: UIImage? = nil,
        isEnabled: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }
}
