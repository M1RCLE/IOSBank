import UIKit

extension UIViewController {
    func openBDUIScreen(
        endpoint: String = "https://alfa-itmo.ru/server/v1/storage/",
        storageKey: String? = nil,
        parameters: [String: String]? = nil,
        title: String? = nil,
        presentationStyle: UIModalPresentationStyle = .pageSheet,
        navigationType: BDUINavigationType = .push,
        username: String? = nil,
        password: String? = nil
    ) {
        let config = BDUIScreenConfig(
            endpoint: endpoint,
            storageKey: storageKey,
            parameters: parameters,
            navigationTitle: title,
            navigationType: navigationType,
            presentationStyle: presentationStyle,
            username: username,
            password: password
        )
        
        openBDUIScreen(with: config)
    }
    
    func openBDUIScreen(with config: BDUIScreenConfig) {
        let viewController = BDUIRouter.createModule(with: config)
        
        switch config.navigationType {
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .present:
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = config.presentationStyle
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: viewController,
                action: #selector(dismissScreen)
            )
            
            present(navController, animated: true)
        }
    }
    
    func openBDUIScreen(
        jsonString: String,
        title: String? = nil,
        presentationStyle: UIModalPresentationStyle = .pageSheet,
        navigationType: BDUINavigationType = .push
    ) {
        let viewController = BDUIRouter.createModule(
            with: jsonString,
            navigationTitle: title
        )
        
        switch navigationType {
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .present:
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = presentationStyle
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: viewController,
                action: #selector(dismissScreen)
            )
            
            present(navController, animated: true)
        }
    }
    
    @objc private func dismissScreen() {
        dismiss(animated: true)
    }
} 