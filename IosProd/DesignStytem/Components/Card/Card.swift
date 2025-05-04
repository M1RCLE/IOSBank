import UIKit

public final class Card: UIView {
    private let titleLabel = Label()
    private let subtitleLabel = Label()
    private let imageView = UIImageView()
    private let stackView = StackView()
    private var viewModel: CardViewModel?
    
    public func configure(with viewModel: CardViewModel) {
        self.viewModel = viewModel
        setupCard()
    }
    
    private func setupCard() {
        guard let viewModel = viewModel else { return }
        
        stackView.configure(with: StackViewConfig(axis: .vertical, spacing: Spacing.small))
        
        if let image = viewModel.image {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            stackView.addArrangedSubview(imageView)
        }
        
        if let title = viewModel.title {
            titleLabel.configure(with: LabelViewModel(text: title, style: .headline))
            stackView.addArrangedSubview(titleLabel)
        }
        
        if let subtitle = viewModel.subtitle {
            subtitleLabel.configure(with: LabelViewModel(text: subtitle, style: .body))
            stackView.addArrangedSubview(subtitleLabel)
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.medium),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.medium)
        ])
        
        layer.cornerRadius = CornerRadius.medium
        
        switch viewModel.style {
        case .elevated:
            backgroundColor = Colors.surface
            layer.shadowColor = Colors.onBackground.cgColor
            layer.shadowOpacity = 0.1
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 4
            
        case .outlined:
            backgroundColor = Colors.surface
            layer.borderWidth = 1
            layer.borderColor = Colors.onBackground.withAlphaComponent(0.1).cgColor
            
        case .filled:
            backgroundColor = Colors.primary.withAlphaComponent(0.1)
        }
        
        if viewModel.action != nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
            addGestureRecognizer(tapGesture)
            isUserInteractionEnabled = true
        }
    }
    
    @objc private func cardTapped() {
        viewModel?.action?()
    }
}
