import UIKit

class BDUIViewController: UIViewController {
    private var mapper: BDUIMapperProtocol!
    private var actionHandler: BDUIActionHandlerProtocol!
    private var jsonData: Data?
    private var rootElement: BDUIElement?
    
    // MARK: - Initialization
    init(jsonData: Data) {
        self.jsonData = jsonData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            fatalError("Invalid JSON string")
        }
        self.init(jsonData: data)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDependencies()
        setupNotifications()
        renderUI()
    }
    
    // MARK: - Setup
    private func setupDependencies() {
        actionHandler = BDUIActionHandler(viewController: self)
        mapper = BDUIMapper(actionHandler: actionHandler)
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
    
    // MARK: - UI Rendering
    func renderUI() {
        guard let jsonData = jsonData else { return }
        
        do {
            let decoder = JSONDecoder()
            rootElement = try decoder.decode(BDUIElement.self, from: jsonData)
            
            if let rootElement = rootElement, let rootView = mapper.mapToView(rootElement) {
                view.subviews.forEach { $0.removeFromSuperview() }
                
                view.addSubview(rootView)
                rootView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    rootView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    rootView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    rootView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    rootView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                ])
            }
        } catch {
            print("Error decoding JSON: \(error)")
            showErrorView(message: "Failed to load UI: \(error.localizedDescription)")
        }
    }
    
    private func showErrorView(message: String) {
        let errorLabel = UILabel()
        errorLabel.text = message
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Notifications
    @objc private func handleReloadScreen() {
        renderUI()
    }
    
    @objc private func handleReloadView(_ notification: Notification) {
        guard let viewId = notification.userInfo?["viewId"] as? String else { return }
        print("Should reload view with ID: \(viewId)")
    }
    
    // MARK: - Public Methods
    func updateUI(with jsonData: Data) {
        self.jsonData = jsonData
        renderUI()
    }
    
    func updateUI(with jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else { return }
        updateUI(with: data)
    }
}

extension BDUIViewController {
    func loadUIFromAPI(for screenName: String) {
        // TODO: пока что нигде не используется, но потом можно быдет подставлять host и название стреницы и будет все чики пуки
        let urlString = "https://api.example.com/ui/\(screenName)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let element = try decoder.decode(BDUIElement.self, from: data)
                
                DispatchQueue.main.async {
                    if let view = self.mapper.mapToView(element) {
                        self.view.subviews.forEach { $0.removeFromSuperview() }
                        
                        self.view.addSubview(view)
                        view.translatesAutoresizingMaskIntoConstraints = false
                        
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
                        ])
                    }
                }
            } catch {
                print("Failed to decode JSON from API: \(error)")
            }
        }.resume()
    }
}

extension UIViewController {
    /// Opens a BDUI Universal Screen with the given configuration parameters
    /// - Parameters:
    ///   - endpoint: The base API endpoint for fetching the UI configuration
    ///   - storageKey: Optional storage key for the alfa-itmo.ru server
    ///   - parameters: Optional additional parameters to include in the request
    ///   - title: Optional navigation title for the screen
    ///   - presentationStyle: The modal presentation style (default is .pageSheet)
    ///   - navigationType: Whether to push or present the screen
    func openBDUIScreen(
        endpoint: String = "https://alfa-itmo.ru/server/v1/storage/",
        storageKey: String? = nil,
        parameters: [String: String]? = nil,
        title: String? = nil,
        presentationStyle: UIModalPresentationStyle = .pageSheet,
        navigationType: BDUINavigationType = .push
    ) {
        let config = BDUIScreenConfig(
            endpoint: endpoint,
            storageKey: storageKey,
            parameters: parameters,
            navigationTitle: title,
            navigationType: navigationType,
            presentationStyle: presentationStyle
        )
        
        openBDUIScreen(with: config)
    }
    
    /// Opens a BDUI Universal Screen with the provided configuration
    /// - Parameter config: The BDUI screen configuration
    func openBDUIScreen(with config: BDUIScreenConfig) {
        let viewController = BDUIUniversalViewController(
            endpoint: config.endpoint,
            storageKey: config.storageKey,
            additionalParameters: config.parameters,
            navigationTitle: config.navigationTitle
        )
        
        switch config.navigationType {
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .present:
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = config.presentationStyle
            
            // Add a close button if presented
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: viewController,
                action: #selector(dismissVC)
            )
            
            present(navController, animated: true)
        }
    }
    
    /// Opens a BDUI Universal Screen using a JSON string
    /// - Parameters:
    ///   - jsonString: The JSON string defining the UI
    ///   - title: Optional navigation title for the screen
    ///   - presentationStyle: The modal presentation style (default is .pageSheet)
    ///   - navigationType: Whether to push or present the screen
    func openBDUIScreen(
        jsonString: String,
        title: String? = nil,
        presentationStyle: UIModalPresentationStyle = .pageSheet,
        navigationType: BDUINavigationType = .push
    ) {
        let viewController = BDUIUniversalViewController(
            jsonString: jsonString,
            navigationTitle: title
        )
        
        switch navigationType {
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .present:
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = presentationStyle
            
            // Add a close button if presented
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: viewController,
                action: #selector(dismissVC)
            )
            
            present(navController, animated: true)
        }
    }
}

/// Represents how the BDUI screen should be navigated to
enum BDUINavigationType {
    case push
    case present
}

/// Extension for the @objc selector
private extension UIViewController {
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

