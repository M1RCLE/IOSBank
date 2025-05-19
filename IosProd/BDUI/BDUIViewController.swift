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
