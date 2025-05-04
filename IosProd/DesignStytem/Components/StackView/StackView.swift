import UIKit

public final class StackView: UIStackView {
    public func configure(with config: StackViewConfig) {
        axis = config.axis
        spacing = config.spacing
        distribution = config.distribution
        alignment = config.alignment
    }
    
    public func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
