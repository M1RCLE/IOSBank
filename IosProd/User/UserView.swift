import UIKit

final class UserViewController: UIViewController, UserViewable {
    // MARK: - VIPER Components
    var presenter: UserPresentable!
    
    // MARK: - UI Components
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let usernameLabel = UILabel()
    private let tableView = UITableView()
    private let errorLabel = UILabel()
    
    // MARK: - Data
    private var accountViewModels: [AccountViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - UserViewable Protocol
    func showLoadingState(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
        }
    }
    
    func displayAccounts(_ accounts: [AccountViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.accountViewModels = accounts
            self?.tableView.reloadData()
            self?.errorLabel.isHidden = true
        }
    }
    
    func displayErrorMessage(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorLabel.text = message
            self?.errorLabel.isHidden = false
        }
    }
    
    func displayUsername(_ name: String) {
        DispatchQueue.main.async { [weak self] in
            self?.usernameLabel.text = "Welcome, \(name)"
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension UserViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        let account = accountViewModels[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(account.accountType) Account"
        content.secondaryText = account.formattedBalance
        content.secondaryTextProperties.color = .systemGreen
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectAccount(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UI Configuration
private extension UserViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUsernameLabel()
        setupTableView()
        setupLoadingIndicator()
        setupErrorLabel()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: "Transactions",
                style: .plain,
                target: self,
                action: #selector(transactionsTapped)
            ),
            UIBarButtonItem(
                title: "Settings",
                style: .plain,
                target: self,
                action: #selector(settingsTapped)
            )
        ]
    }
    
    func setupUsernameLabel() {
        usernameLabel.font = .preferredFont(forTextStyle: .title2)
        usernameLabel.textAlignment = .center
        view.addSubview(usernameLabel)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AccountCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 68
        tableView.separatorInset = .zero
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupLoadingIndicator() {
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupErrorLabel() {
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        view.addSubview(errorLabel)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc func transactionsTapped() {
        presenter.transactionsTapped()
    }
    
    @objc func settingsTapped() {
        presenter.settingsTapped()
    }
}
