import UIKit

class ServicesViewController: UIViewController, ServicesViewable, TableManagerDelegate {
    private var tableManager: ProductTableManagable!
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Colors.primary
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.primary
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var noDataView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        // Use StackView from design system
        let stackView = StackView()
        stackView.configure(with: StackViewConfig(
            axis: .vertical,
            spacing: Spacing.medium,
            alignment: .center
        ))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Image
        let imageView = UIImageView(image: UIImage(systemName: "doc.text.magnifyingglass"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.onBackground.withAlphaComponent(0.5)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Labels
        let titleLabel = Label()
        titleLabel.configure(with: LabelViewModel(
            text: "No products found",
            style: .headline,
            alignment: .center
        ))
        
        let subtitleLabel = Label()
        subtitleLabel.configure(with: LabelViewModel(
            text: "Try refreshing or check back later",
            style: .body,
            color: Colors.onBackground.withAlphaComponent(0.7),
            alignment: .center
        ))
        
        // Button
        let refreshButton = Button()
        refreshButton.configure(with: ButtonViewModel(
            title: "Refresh",
            style: .primary,
            action: { [weak self] in
                self?.refreshData()
            }
        ))
        
        // Add all components to stack
        stackView.addArrangedSubviews([imageView, titleLabel, subtitleLabel, refreshButton])
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Spacing.large),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Spacing.large)
        ])
        
        return view
    }()
    
    var presenter: ServicesPresentable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableManager()
        setupUI()
        setupNavigationBar()
        presenter?.viewDidLoad()
    }
    
    private func setupTableManager() {
        tableManager = ProductsTableManager()
        tableManager.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.background
        title = "Banking Products"
        
        let tableView = tableManager.getTableView()
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = Colors.background
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            noDataView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noDataView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        settingsButton.tintColor = Colors.primary
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc private func settingsButtonTapped() {
        presenter?.showSettings()
    }
    
    @objc private func refreshData() {
        presenter?.refreshData()
    }
    
    // MARK: - ServicesViewable
    
    func showLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isLoading {
                self?.loadingIndicator.startAnimating()
                self?.noDataView.isHidden = true
            } else {
                self?.loadingIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func showProducts(_ products: [EnhancedProductViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.noDataView.isHidden = !products.isEmpty
            self?.tableManager.updateData(with: products)
        }
    }
    
    func showError(_ message: String) {
        // Use alert controller temporarily, but could be enhanced with a custom design system alert
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    // MARK: - TableManagerDelegate
    
    func didSelectItem(at index: Int) {
        presenter?.didSelectProduct(at: index)
    }
}
