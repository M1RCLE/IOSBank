import UIKit

final class BDUIRouter: BDUIRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Module Creation
    
    static func createModule(with config: BDUIScreenConfig) -> UIViewController {
        let view = BDUIViewController()
        let presenter = BDUIPresenter(with: config)
        let interactor = BDUIInteractor()
        let router = BDUIRouter(viewController: view)
        let mapper = BDUIMapper()
        
        view.presenter = presenter
        view.setMapper(mapper)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        view.title = config.navigationTitle
        
        return view
    }
    
    static func createModule(with jsonString: String, navigationTitle: String?) -> UIViewController {
        let view = BDUIViewController()
        let presenter = BDUIPresenter(with: jsonString, navigationTitle: navigationTitle)
        let interactor = BDUIInteractor()
        let router = BDUIRouter(viewController: view)
        let mapper = BDUIMapper()
        
        view.presenter = presenter
        view.setMapper(mapper)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        view.title = navigationTitle
        
        return view
    }
    
    // MARK: - Navigation
    
    func navigate(to route: String, with parameters: [String: Any]?) {
        guard let parameters = parameters else { return }
        
        // Convert parameters to string dictionary for config
        var stringParameters: [String: String] = [:]
        parameters.forEach { key, value in
            if let stringValue = value as? String {
                stringParameters[key] = stringValue
            } else {
                stringParameters[key] = "\(value)"
            }
        }
        
        let config = BDUIScreenConfig(
            endpoint: route,
            parameters: stringParameters
        )
        
        let destinationViewController = BDUIRouter.createModule(with: config)
        
        if config.navigationType == .push {
            viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: destinationViewController)
            navigationController.modalPresentationStyle = config.presentationStyle
            
            destinationViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: destinationViewController,
                action: #selector(UIViewController.dismissSelf)
            )
            
            viewController?.present(navigationController, animated: true)
        }
    }
    
    func dismissView(animated: Bool) {
        if viewController?.navigationController?.viewControllers.count ?? 0 > 1 {
            viewController?.navigationController?.popViewController(animated: animated)
        } else {
            viewController?.dismiss(animated: animated)
        }
    }
}

// Helper extension
private extension UIViewController {
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
} 