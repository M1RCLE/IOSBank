import UIKit

public final class Button: UIButton {
    private var viewModel: ButtonViewModel?
    
    public func configure(with viewModel: ButtonViewModel) {
        self.viewModel = viewModel
        setupButton()
    }
    
    private func setupButton() {
        guard let viewModel = viewModel else { return }
        
        setTitle(viewModel.title, for: .normal)
        isEnabled = viewModel.isEnabled
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        if let icon = viewModel.icon {
            setImage(icon, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Spacing.small)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: Spacing.small, bottom: 0, right: 0)
        }
        
        layer.cornerRadius = CornerRadius.medium
        titleLabel?.font = Typography.body
        
        switch viewModel.style {
        case .primary:
            backgroundColor = viewModel.isEnabled ? Colors.primary : Colors.primary.withAlphaComponent(0.5)
            setTitleColor(Colors.onPrimary, for: .normal)
            setTitleColor(Colors.onPrimary.withAlphaComponent(0.5), for: .disabled)
            
        case .secondary:
            backgroundColor = viewModel.isEnabled ? Colors.secondary : Colors.secondary.withAlphaComponent(0.5)
            setTitleColor(Colors.onSecondary, for: .normal)
            setTitleColor(Colors.onSecondary.withAlphaComponent(0.5), for: .disabled)
            
        case .outlined:
            backgroundColor = .clear
            layer.borderWidth = 1
            layer.borderColor = viewModel.isEnabled ? Colors.primary.cgColor : Colors.primary.withAlphaComponent(0.5).cgColor
            setTitleColor(viewModel.isEnabled ? Colors.primary : Colors.primary.withAlphaComponent(0.5), for: .normal)
            
        case .text:
            backgroundColor = .clear
            setTitleColor(viewModel.isEnabled ? Colors.primary : Colors.primary.withAlphaComponent(0.5), for: .normal)
        }
        
        contentEdgeInsets = UIEdgeInsets(
            top: Spacing.small,
            left: Spacing.medium,
            bottom: Spacing.small,
            right: Spacing.medium
        )
    }
    
    @objc private func buttonTapped() {
        viewModel?.action?()
    }
}
