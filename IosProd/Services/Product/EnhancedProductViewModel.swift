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
    
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let productImageView = UIImageView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let detailsArrow = UIImageView()
    private let cardView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Card view setup
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardView)
        
        // Image view setup
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        productImageView.backgroundColor = .systemGray6
        
        // Loading indicator setup
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .systemBlue
        
        // Labels setup
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        categoryLabel.font = UIFont.systemFont(ofSize: 12)
        categoryLabel.textColor = .systemBlue
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 2
        
        // Arrow setup
        detailsArrow.image = UIImage(systemName: "chevron.right")
        detailsArrow.tintColor = .systemGray
        detailsArrow.contentMode = .scaleAspectFit
        
        [productImageView, loadingIndicator, titleLabel, categoryLabel, descriptionLabel, detailsArrow].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }
        
        // Layout constraints
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            productImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            productImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            productImageView.heightAnchor.constraint(equalToConstant: 60),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: detailsArrow.leadingAnchor, constant: -8),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: detailsArrow.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            detailsArrow.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            detailsArrow.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            detailsArrow.widthAnchor.constraint(equalToConstant: 16),
            detailsArrow.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configure(with viewModel: EnhancedProductViewModel) {
        titleLabel.text = viewModel.title
        categoryLabel.text = viewModel.category.uppercased()
        descriptionLabel.text = viewModel.shortDescription
        
        // Reset image and show loading indicator
        productImageView.image = nil
        loadingIndicator.startAnimating()
        
        // Load image if URL is available
        if let imageUrl = viewModel.imageUrl {
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    
                    if let data = data, let image = UIImage(data: data) {
                        self?.productImageView.image = image
                    } else {
                        // Show placeholder if image loading fails
                        self?.productImageView.image = UIImage(systemName: "photo")
                        self?.productImageView.tintColor = .systemGray3
                    }
                }
            }.resume()
        } else {
            loadingIndicator.stopAnimating()
            productImageView.image = UIImage(systemName: "photo")
            productImageView.tintColor = .systemGray3
        }
    }
}
