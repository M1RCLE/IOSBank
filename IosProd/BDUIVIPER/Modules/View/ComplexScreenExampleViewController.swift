import UIKit

/// This class demonstrates how to implement a complex screen using the BDUI framework
class ComplexScreenExampleViewController: UIViewController {
    
    private let loginField = UITextField()
    private let passwordField = UITextField()
    private let loadButton = UIButton(type: .system)
    private let screenTypeSegment = UISegmentedControl(items: ["Basic", "Complex", "Custom"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "BDUI Demo"
        view.backgroundColor = .systemBackground
        
        // Setup login field with default value
        loginField.placeholder = "Username"
        loginField.borderStyle = .roundedRect
        loginField.autocapitalizationType = .none
        loginField.autocorrectionType = .no
        loginField.text = "369069" // Default username
        
        // Setup password field with default value
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.text = "Q8gDgYmEszLn" // Default password
        
        // Setup segment control
        screenTypeSegment.selectedSegmentIndex = 0
        
        // Setup button
        loadButton.setTitle("Load BDUI Screen", for: .normal)
        loadButton.addTarget(self, action: #selector(loadBDUIScreen), for: .touchUpInside)
        
        // Add description label
        let descLabel = UILabel()
        descLabel.text = "This example demonstrates how to load a Backend Driven UI screen. The default credentials for the alfa-itmo.ru Storage API are pre-filled."
        descLabel.numberOfLines = 0
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textColor = .secondaryLabel
        
        // Add subviews
        [descLabel, loginField, passwordField, screenTypeSegment, loadButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // Layout constraints
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loginField.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            loginField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 12),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            
            screenTypeSegment.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            screenTypeSegment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            screenTypeSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loadButton.topAnchor.constraint(equalTo: screenTypeSegment.bottomAnchor, constant: 30),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadButton.widthAnchor.constraint(equalToConstant: 200),
            loadButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func loadBDUIScreen() {
        let username = loginField.text?.isEmpty == false ? loginField.text : nil
        let password = passwordField.text?.isEmpty == false ? passwordField.text : nil
        
        var config: BDUIScreenConfig
        
        switch screenTypeSegment.selectedSegmentIndex {
        case 0:
            config = BDUIScreenConfig.storage(
                key: "basic_ui_example",
                title: "Basic UI",
                username: username,
                password: password
            )
            
        case 1:
            config = BDUIScreenConfig.storage(
                key: "complex_ui_example",
                title: "Complex UI",
                username: username,
                password: password
            )
            
        case 2:
            config = BDUIScreenConfig.custom(
                endpoint: "https://alfa-itmo.ru/server/v1/custom/ui",
                parameters: ["theme": "dark", "mode": "full"],
                title: "Custom UI",
                username: username,
                password: password
            )
            
        default:
            return
        }
        
        openBDUIScreen(with: config)
    }
}
