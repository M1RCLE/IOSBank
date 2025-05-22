import UIKit

final class BDUIViewController: UIViewController, BDUIViewProtocol {
    var presenter: BDUIPresenterProtocol?
    
    private var loadingIndicator: UIActivityIndicatorView!
    private var mapper: BDUIMapperProtocol!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupLoadingIndicator()
        setupNotifications()
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleReloadScreen),
            name: NSNotification.Name("ReloadScreen"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleReloadView(_:)),
            name: NSNotification.Name("ReloadView"),
            object: nil
        )
    }
    
    // MARK: - BDUIViewProtocol
    
    func showLoading() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func showError(message: String) {
        let errorLabel = UILabel()
        errorLabel.text = message
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        view.subviews.forEach { subview in
            if subview != loadingIndicator {
                subview.removeFromSuperview()
            }
        }
        
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func renderUI(with element: BDUIElement) {
        guard let rootView = mapper.mapToView(element) else { return }
        
        view.subviews.forEach { subview in
            if subview != loadingIndicator {
                subview.removeFromSuperview()
            }
        }
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(rootView)
        rootView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func handleReloadScreen() {
        presenter?.viewDidLoad()
    }
    
    @objc private func handleReloadView(_ notification: Notification) {
        guard let viewId = notification.userInfo?["viewId"] as? String else { return }
        print("Should update view with ID: \(viewId)")
    }
    
    // MARK: - Public Methods
    
    func setMapper(_ mapper: BDUIMapperProtocol) {
        self.mapper = mapper
    }
} 