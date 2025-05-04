import UIKit

public final class Button: UIButton {
    private var viewModel: ButtonViewModel?
    
    public func configure(with viewModel: ButtonViewModel) {
        self.viewModel = viewModel
        setupButton()
    }
    
    private func setupButton() {
        guard let viewModel = viewModel else { return }
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = viewModel.title
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = Typography.body
            return outgoing
        }
        
        if let icon = viewModel.icon {
            configuration.image = icon
            configuration.imagePadding = Spacing.small
            configuration.imagePlacement = .leading
        }
        
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Spacing.small,
            leading: Spacing.medium,
            bottom: Spacing.small,
            trailing: Spacing.medium
        )
        
        switch viewModel.style {
        case .primary:
            configuration.baseBackgroundColor = viewModel.isEnabled ? Colors.primary : Colors.primary.withAlphaComponent(0.5)
            configuration.baseForegroundColor = Colors.onPrimary
            
        case .secondary:
            configuration.baseBackgroundColor = viewModel.isEnabled ? Colors.secondary : Colors.secondary.withAlphaComponent(0.5)
            configuration.baseForegroundColor = Colors.onSecondary
            
        case .outlined:
            configuration.background.strokeColor = viewModel.isEnabled ? Colors.primary : Colors.primary.withAlphaComponent(0.5)
            configuration.background.strokeWidth = 1
            configuration.baseForegroundColor = viewModel.isEnabled ? Colors.primary : Colors.primary.withAlphaComponent(0.5)
            
        case .text:
            configuration.baseForegroundColor = viewModel.isEnabled ? Colors.primary : Colors.primary.withAlphaComponent(0.5)
        }
        
        configuration.cornerStyle = .fixed
        configuration.background.cornerRadius = CornerRadius.medium
        self.configuration = configuration
        
        isEnabled = viewModel.isEnabled
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        viewModel?.action?()
    }
}
