import UIKit

public final class TextInput: UITextField {
    private var viewModel: TextInputViewModel?
    
    public func configure(with viewModel: TextInputViewModel) {
        self.viewModel = viewModel
        setupTextField()
    }
    
    private func setupTextField() {
        guard let viewModel = viewModel else { return }
        
        placeholder = viewModel.placeholder
        text = viewModel.text
        isSecureTextEntry = viewModel.isSecure
        font = Typography.body
        delegate = self
        
        isUserInteractionEnabled = true
        
        if let leftIcon = viewModel.leftIcon {
            let iconView = UIImageView(image: leftIcon)
            iconView.tintColor = Colors.onBackground.withAlphaComponent(0.6)
            leftView = iconView
            leftViewMode = .always
            leftView?.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        }
        
        if let rightIcon = viewModel.rightIcon {
            let iconView = UIImageView(image: rightIcon)
            iconView.tintColor = Colors.onBackground.withAlphaComponent(0.6)
            rightView = iconView
            rightViewMode = .always
            rightView?.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        }
        
        
        switch viewModel.style {
        case .standard:
            layer.cornerRadius = 0
            layer.borderWidth = 0
            layer.borderColor = nil
            backgroundColor = .clear
            borderStyle = .none
            
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
            bottomLine.backgroundColor = Colors.onBackground.withAlphaComponent(0.2).cgColor
            layer.addSublayer(bottomLine)
            
        case .outlined:
            layer.cornerRadius = CornerRadius.medium
            layer.borderWidth = 1
            layer.borderColor = Colors.onBackground.withAlphaComponent(0.2).cgColor
            backgroundColor = .clear
            borderStyle = .none
            
        case .error:
            layer.cornerRadius = CornerRadius.medium
            layer.borderWidth = 1
            layer.borderColor = Colors.error.cgColor
            backgroundColor = .clear
            borderStyle = .none
        }
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.small, height: frame.height))
        leftView = leftView ?? paddingView
        leftViewMode = .always
    }
}

extension TextInput: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel?.onTextChange?(textField.text ?? "")
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
