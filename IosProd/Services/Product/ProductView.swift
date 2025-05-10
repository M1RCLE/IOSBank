import UIKit

struct EnhancedProductViewModel {
    let id: Int
    let title: String
    let shortDescription: String
    let category: String
    let imageUrl: URL?
    
    init(from product: ProductDTO) {
        self.id = product.id
        self.title = product.title
        self.shortDescription = String(product.description.prefix(100)) + (product.description.count > 100 ? "..." : "")
        self.category = product.category
        self.imageUrl = URL(string: "https://picsum.photos/200/300?id=\(product.id)")
    }
}

class ProductView: UIView, ConfigurableView {
    typealias ViewModel = EnhancedProductViewModel
    
    private let titleLabel = Label()
    private let descriptionLabel = Label()
    private let productImageView = UIImageView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let detailsArrow = UIImageView()
    private let card = Card()
    private let contentStack = StackView()
    private let textStack = StackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = CornerRadius.small
        productImageView.backgroundColor = Colors.background
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = Colors.primary
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        detailsArrow.image = UIImage(systemName: "chevron.right")
        detailsArrow.tintColor = Colors.onBackground.withAlphaComponent(0.6)
        detailsArrow.contentMode = .scaleAspectFit
        detailsArrow.translatesAutoresizingMaskIntoConstraints = false
        
        textStack.configure(with: StackViewConfig(axis: .vertical, spacing: Spacing.xxSmall))
        contentStack.configure(with: StackViewConfig(axis: .horizontal, spacing: Spacing.medium))
        
        productImageView.addSubview(loadingIndicator)
        
        textStack.addArrangedSubviews([titleLabel, descriptionLabel])
        contentStack.addArrangedSubviews([productImageView, textStack, detailsArrow])
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            productImageView.heightAnchor.constraint(equalToConstant: 60),
            
            detailsArrow.widthAnchor.constraint(equalToConstant: 16),
            detailsArrow.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.xSmall),
            card.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
            card.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.medium),
            card.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.xSmall)
        ])
        
        let cardViewModel = CardViewModel(style: .elevated, action: nil)
        card.configure(with: cardViewModel)
        
        card.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: card.topAnchor, constant: Spacing.medium),
            contentStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: Spacing.medium),
            contentStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -Spacing.medium),
            contentStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Spacing.medium)
        ])
    }
    
    func configure(with viewModel: EnhancedProductViewModel) {
        titleLabel.configure(with: LabelViewModel(
            text: viewModel.title,
            style: .headline
        ))
        
        descriptionLabel.configure(with: LabelViewModel(
            text: viewModel.shortDescription,
            style: .body,
            color: Colors.onBackground.withAlphaComponent(0.7)
        ))
        
        productImageView.image = nil
        loadingIndicator.startAnimating()
        
        if let imageUrl = viewModel.imageUrl {
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    
                    if let data = data, let image = UIImage(data: data) {
                        self?.productImageView.image = image
                    } else {
                        self?.productImageView.image = UIImage(systemName: "photo")
                        self?.productImageView.tintColor = Colors.onBackground.withAlphaComponent(0.3)
                    }
                }
            }.resume()
        } else {
            loadingIndicator.stopAnimating()
            productImageView.image = UIImage(systemName: "photo")
            productImageView.tintColor = Colors.onBackground.withAlphaComponent(0.3)
        }
    }
}
