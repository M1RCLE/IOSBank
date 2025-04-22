import UIKit

protocol ConfigurableView: UIView {
    associatedtype ViewModel
    func configure(with viewModel: ViewModel)
}

class GenericCell<ContentView: ConfigurableView>: UITableViewCell {
    private let customView = ContentView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        customView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: ContentView.ViewModel) {
        customView.configure(with: viewModel)
    }
}

// Example of a ProductView that can be used with GenericCell
class ProductView: UIView, ConfigurableView {
    // UI components
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let descriptionLabel = UILabel()
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
        // Same UI setup as in ProductCell
        // ...
    }
    
    func configure(with viewModel: ProductViewModel) {
        titleLabel.text = viewModel.title
        categoryLabel.text = viewModel.category.uppercased()
        descriptionLabel.text = viewModel.shortDescription
    }
}

// Usage example:
// tableView.register(GenericCell<ProductView>.self, forCellReuseIdentifier: "ProductCell")
