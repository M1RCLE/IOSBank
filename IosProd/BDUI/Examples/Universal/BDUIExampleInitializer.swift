import UIKit

class BDUIExampleInitializer {
    static func addDemoButton(to viewController: UIViewController) {
        let button = UIButton(type: .system)
        button.setTitle("Open BDUI Demo", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        
        button.addAction(UIAction { _ in
            let demoViewController = ComplexScreenExampleViewController()
            if let navigationController = viewController.navigationController {
                navigationController.pushViewController(demoViewController, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: demoViewController)
                navController.modalPresentationStyle = .fullScreen
                viewController.present(navController, animated: true)
            }
        }, for: .touchUpInside)
        
        viewController.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    static func addDirectDemoButton(to viewController: UIViewController, type: BDUIDemoType) {
        let button = UIButton(type: .system)
        button.setTitle("Open \(type.title)", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        
        button.addAction(UIAction { _ in
            let username = "369069"
            let password = "Q8gDgYmEszLn"
            
            var config: BDUIScreenConfig
            
            switch type {
            case .basic:
                config = BDUIScreenConfig.storage(
                    key: "basic_ui_example",
                    title: "Basic UI",
                    username: username,
                    password: password
                )
                
            case .complex:
                config = BDUIScreenConfig.storage(
                    key: "complex_ui_example",
                    title: "Complex UI",
                    username: username,
                    password: password
                )
                
            case .custom:
                config = BDUIScreenConfig.custom(
                    endpoint: "https://alfa-itmo.ru/server/v1/storage",
                    parameters: ["theme": "dark", "mode": "full"],
                    title: "Custom UI",
                    username: username,
                    password: password
                )
            }
            
            viewController.openBDUIScreen(with: config)
        }, for: .touchUpInside)
        
        viewController.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

/// Enum representing different types of BDUI demo screens
enum BDUIDemoType: Int {
    case basic = 1
    case complex = 2
    case custom = 3
    
    var title: String {
        switch self {
        case .basic: return "Basic BDUI"
        case .complex: return "Complex BDUI"
        case .custom: return "Custom BDUI"
        }
    }
} 
