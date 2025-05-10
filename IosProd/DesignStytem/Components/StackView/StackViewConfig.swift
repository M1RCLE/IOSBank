import UIKit

public struct StackViewConfig {
    public let axis: NSLayoutConstraint.Axis
    public let spacing: CGFloat
    public let distribution: UIStackView.Distribution
    public let alignment: UIStackView.Alignment
    
    public init(
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: CGFloat = Spacing.medium,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) {
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
    }
}
