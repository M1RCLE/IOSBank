import UIKit

protocol ConfigurableView {
    associatedtype ViewModel
    func configure(with viewModel: ViewModel)
}

class GenericCell<View: UIView & ConfigurableView>: UITableViewCell {
    
    private let customView: View
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        customView = View()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        customView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    func configure(with viewModel: View.ViewModel) {
        customView.configure(with: viewModel)
    }
}
