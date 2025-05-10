import UIKit

public struct CardViewModel {
    public let title: String?
    public let subtitle: String?
    public let image: UIImage?
    public let style: CardStyle
    public let action: (() -> Void)?
    
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        image: UIImage? = nil,
        style: CardStyle = .elevated,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.style = style
        self.action = action
    }
}
