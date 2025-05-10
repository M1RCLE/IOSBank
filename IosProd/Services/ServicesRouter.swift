import UIKit

class ServicesRouter: ServicesRoutable {
    weak var viewController: UIViewController?
    
    func navigateToProductDetails(product: ProductDTO) {
        let alertView = UIView()
        alertView.backgroundColor = Colors.background
        alertView.layer.cornerRadius = CornerRadius.medium
        
        // Stack for content
        let contentStack = StackView()
        contentStack.configure(with: StackViewConfig(axis: .vertical, spacing: Spacing.medium))
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        let titleLabel = Label()
        titleLabel.configure(with: LabelViewModel(
            text: product.title,
            style: .headline,
            alignment: .center
        ))
        
        // Description
        let descriptionLabel = Label()
        descriptionLabel.configure(with: LabelViewModel(
            text: product.description,
            style: .body,
            alignment: .natural
        ))
        
        // Category
        let categoryContainer = UIView()
        categoryContainer.translatesAutoresizingMaskIntoConstraints = false
        categoryContainer.backgroundColor = Colors.primary.withAlphaComponent(0.1)
        categoryContainer.layer.cornerRadius = CornerRadius.small
        
        let categoryLabel = Label()
        categoryLabel.configure(with: LabelViewModel(
            text: product.category.uppercased(),
            style: .caption,
            color: Colors.primary,
            alignment: .center
        ))
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryContainer.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: categoryContainer.topAnchor, constant: Spacing.xxSmall),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor, constant: Spacing.xSmall),
            categoryLabel.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor, constant: -Spacing.xSmall),
            categoryLabel.bottomAnchor.constraint(equalTo: categoryContainer.bottomAnchor, constant: -Spacing.xxSmall)
        ])
        
        // Close button
        let closeButton = Button()
        closeButton.configure(with: ButtonViewModel(
            title: "Close",
            style: .primary,
            action: { [weak self] in
                self?.viewController?.dismiss(animated: true)
            }
        ))
        
        // Add components to stack
        contentStack.addArrangedSubviews([titleLabel, categoryContainer, descriptionLabel, closeButton])
        
        alertView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: alertView.topAnchor, constant: Spacing.medium),
            contentStack.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: Spacing.medium),
            contentStack.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -Spacing.medium),
            contentStack.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -Spacing.medium)
        ])
        
        // Present in a custom alert controller
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(alertView, forKey: "contentViewController")
        
        viewController?.present(alert, animated: true)
    }
    
    func showErrorAlert(message: String) {
        // Using standard alert controller for errors
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
    
    func navigateToSettings() {
        // Navigate to settings screen
        let settingsVC = SettingsBuilder.build()
        viewController?.navigationController?.pushViewController(settingsVC, animated: true)
    }
}
