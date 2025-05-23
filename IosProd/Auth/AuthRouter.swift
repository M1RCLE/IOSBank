import UIKit

class AuthRouter: AuthRoutable {
    weak var viewController: UIViewController?
    
    func navigateToServices() {
        DispatchQueue.main.async { [weak self] in
            let servicesVC = ServicesBuilder.build()
            
            if let navigationController = self?.viewController?.navigationController {
                navigationController.setViewControllers([servicesVC], animated: true)
            } else {
                let navigationController = UINavigationController(rootViewController: servicesVC)
                navigationController.modalPresentationStyle = .fullScreen
                self?.viewController?.present(navigationController, animated: true)
            }
        }
    }
    
    func navigateToPasswordRecovery() {
        let passwordRecoveryVC = PasswordRecoveryBuilder.build()
        viewController?.navigationController?.pushViewController(passwordRecoveryVC, animated: true)
    }
}
