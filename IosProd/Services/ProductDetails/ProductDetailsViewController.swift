import UIKit

class ProductDetailsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let productImageView = UIImageView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let titleLabel = UILabel()
    private let categoryChip = UIView()
    private let categoryLabel = UILabel()
    private let descriptionHeaderLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let product: ProductDTO
    
    // MARK: - Initialization
    init(product: ProductDTO) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithProduct()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Product Details"
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.backgroundColor = .systemGray6
        productImageView.layer.cornerRadius = 8
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryChip.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        categoryChip.layer.cornerRadius = 12
        categoryChip.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.font = UIFont.systemFont(ofSize: 12)
        categoryLabel.textColor = .systemBlue
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryChip.addSubview(categoryLabel)
        
        descriptionHeaderLabel.text = "Description"
        descriptionHeaderLabel.font = UIFont.boldSystemFont(ofSize: 18)
        descriptionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        priceLabel.textColor = .systemGreen
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(productImageView)
        contentView.addSubview(loadingIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryChip)
        contentView.addSubview(descriptionHeaderLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryChip.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            categoryChip.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryChip.heightAnchor.constraint(equalToConstant: 24),
            
            categoryLabel.topAnchor.constraint(equalTo: categoryChip.topAnchor, constant: 4),
            categoryLabel.bottomAnchor.constraint(equalTo: categoryChip.bottomAnchor, constant: -4),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryChip.leadingAnchor, constant: 12),
            categoryLabel.trailingAnchor.constraint(equalTo: categoryChip.trailingAnchor, constant: -12),
            
            priceLabel.centerYAnchor.constraint(equalTo: categoryChip.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionHeaderLabel.topAnchor.constraint(equalTo: categoryChip.bottomAnchor, constant: 24),
            descriptionHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionHeaderLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Configuration
    private func configureWithProduct() {
        titleLabel.text = product.title
        categoryLabel.text = product.category.uppercased()
        descriptionLabel.text = product.description
        
        priceLabel.text = "$\(Int.random(in: 50...500))"
        
        productImageView.image = nil
        loadingIndicator.startAnimating()
        
        if let imageUrl = URL(string: "https://picsum.photos/600/600?id=\(product.id)") {
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    
                    if let data = data, let image = UIImage(data: data) {
                        self?.productImageView.image = image
                    } else {
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
