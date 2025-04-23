import UIKit

class ProductCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let detailsArrow = UIImageView()
    private let cardView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // MARK: - Card view setup
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        // MARK: - Labels setup
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        categoryLabel.font = UIFont.systemFont(ofSize: 12)
        categoryLabel.textColor = .systemBlue
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 2
        
        // MARK: - Arrow setup
        detailsArrow.image = UIImage(systemName: "chevron.right")
        detailsArrow.tintColor = .systemGray
        detailsArrow.contentMode = .scaleAspectFit
        
        [titleLabel, categoryLabel, descriptionLabel, detailsArrow].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }
        
        // MARK: - Layout constraints
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: detailsArrow.leadingAnchor, constant: -8),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: detailsArrow.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            detailsArrow.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            detailsArrow.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            detailsArrow.widthAnchor.constraint(equalToConstant: 16),
            detailsArrow.heightAnchor.constraint(equalToConstant: 16)
        ])

        selectionStyle = .none
        backgroundColor = .clear
    }
    
    func configure(with viewModel: ProductViewModel) {
        titleLabel.text = viewModel.title
        categoryLabel.text = viewModel.category.uppercased()
        descriptionLabel.text = viewModel.shortDescription
    }
}
