import UIKit

final class BDUIUniversalViewController: UIViewController {
    private var mapper: BDUIMapperProtocol!
    private var actionHandler: BDUIActionHandlerProtocol!
    private var loadingIndicator: UIActivityIndicatorView!
    
    // Configuration
    private var endpoint: String
    private var storageKey: String?
    private var additionalParameters: [String: String]?
    private var navigationTitle: String?
    
    // Auth credentials
    private var username: String?
    private var password: String?
    
    // For directly loading from a string (testing)
    private var jsonString: String?
    
    // MARK: - Initialization
    init(
        endpoint: String,
        storageKey: String? = nil,
        additionalParameters: [String: String]? = nil,
        navigationTitle: String? = nil,
        username: String? = nil,
        password: String? = nil
    ) {
        self.endpoint = endpoint
        self.storageKey = storageKey
        self.additionalParameters = additionalParameters
        self.navigationTitle = navigationTitle
        self.username = username
        self.password = password
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Convenience initializer for loading from a JSON string (for testing purposes)
    convenience init(jsonString: String, navigationTitle: String? = nil) {
        self.init(endpoint: "")
        self.jsonString = jsonString
        self.navigationTitle = navigationTitle
    }
    
    required init?(coder: NSCoder) {
        self.endpoint = "https://alfa-itmo.ru/server/v1/storage/"
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = navigationTitle
        
        setupDependencies()
        setupLoadingIndicator()
        setupNotifications()
        
        if let jsonString = jsonString {
            // If we have a JSON string, load from it directly
            if let data = jsonString.data(using: .utf8) {
                renderUI(with: data)
            } else {
                showError(message: "Invalid JSON string")
            }
        } else {
            // Otherwise, load from the endpoint
            loadUIConfiguration()
        }
    }
    
    // MARK: - Setup
    private func setupDependencies() {
        actionHandler = BDUIActionHandler(viewController: self)
        mapper = BDUIMapper(actionHandler: actionHandler)
    }
    
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
    
    // MARK: - Data Loading
    private func loadUIConfiguration() {
        loadingIndicator.startAnimating()
        
        // Construct the URL
        var finalEndpoint = endpoint
        if let key = storageKey {
            // Handle storage endpoint format
            if finalEndpoint.hasSuffix("/") {
                finalEndpoint += key
            } else {
                finalEndpoint += "/\(key)"
            }
        }
        
        // Add query parameters if any
        if let parameters = additionalParameters, !parameters.isEmpty {
            var queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            
            if var urlComponents = URLComponents(string: finalEndpoint) {
                urlComponents.queryItems = queryItems
                if let url = urlComponents.url {
                    finalEndpoint = url.absoluteString
                }
            }
        }
        
        guard let url = URL(string: finalEndpoint) else {
            showError(message: "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        
        if let username = username, let password = password {
            let loginString = "\(username):\(password)"
            if let loginData = loginString.data(using: .utf8) {
                let base64LoginString = loginData.base64EncodedString()
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            }
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                
                if let error = error {
                    self.showError(message: "Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showError(message: "Invalid response")
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                        self.showError(message: "Authentication failed. Please check your credentials.")
                    } else if httpResponse.statusCode == 404 {
                        self.showError(message: "Resource not found. Check storage key or endpoint.")
                    } else {
                        self.showError(message: "Server error: \(httpResponse.statusCode)")
                    }
                    return
                }
                
                guard let data = data else {
                    self.showError(message: "No data received")
                    return
                }
                
                self.renderUI(with: data)
            }
        }.resume()
    }
    
    private func renderUI(with data: Data) {
        do {
            let decoder = JSONDecoder()
            let rootElement = try decoder.decode(BDUIElement.self, from: data)
            
            if let rootView = mapper.mapToView(rootElement) {
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
        } catch {
            showError(message: "Failed to parse UI: \(error.localizedDescription)")
        }
    }
    
    private func showError(message: String) {
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
    
    @objc private func handleReloadScreen() {
        loadUIConfiguration()
    }
    
    @objc private func handleReloadView(_ notification: Notification) {
        guard let viewId = notification.userInfo?["viewId"] as? String else { return }
        print("Should reload view with ID: \(viewId)")
    }
    
    func updateEndpoint(_ endpoint: String, storageKey: String? = nil) {
        self.endpoint = endpoint
        self.storageKey = storageKey
        loadUIConfiguration()
    }
    
    func updateParameters(_ parameters: [String: String]?) {
        self.additionalParameters = parameters
        loadUIConfiguration()
    }
    
    func updateCredentials(username: String?, password: String?) {
        self.username = username
        self.password = password
        loadUIConfiguration()
    }
} 
