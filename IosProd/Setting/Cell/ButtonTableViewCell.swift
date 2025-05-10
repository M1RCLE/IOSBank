import UIKit

class ButtonTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private var buttonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            actionButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(title: String, buttonTitle: String, style: UIAlertAction.Style, action: @escaping () -> Void) {
        titleLabel.text = title
        actionButton.setTitle(buttonTitle, for: .normal)
        
        switch style {
        case .default:
            actionButton.setTitleColor(.systemBlue, for: .normal)
        case .destructive:
            actionButton.setTitleColor(.systemRed, for: .normal)
        case .cancel:
            actionButton.setTitleColor(.systemGray, for: .normal)
        @unknown default:
            actionButton.setTitleColor(.systemBlue, for: .normal)
        }
        
        buttonAction = action
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
}
