import UIKit

class ServicesViewController: UIViewController, ServicesViewable, TableManagerDelegate {
    private var tableManager: ProductTableManagable!
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var noDataView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(systemName: "doc.text.magnifyingglass"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "No products found"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16)
        
        let button = UIButton(type: .system)
        button.setTitle("Refresh", for: .normal)
        button.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
        view.backgroundColor = .white
        title = "Banking Products"
        
        let tableView = tableManager.getTableView()
        tableView.refreshControl = refreshControl
        
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
        navigationItem.hidesBackButton = true // Hide back button since this is post-login
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
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
