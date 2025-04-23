import UIKit

class ServicesViewController: UIViewController, ServicesViewable, TableManagerDelegate {
    private var tableManager: TableManagerProtocol!
    
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
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
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
            } else {
                self?.loadingIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func showProducts(_ products: [ProductViewModel]) {
        tableManager.updateData(with: products)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - TableManagerDelegate
    
    func didSelectItem(at index: Int) {
        presenter?.didSelectProduct(at: index)
    }
}
