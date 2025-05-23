import UIKit

class ValueTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        valueLabel.textColor = .gray
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        accessoryType = .disclosureIndicator
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
