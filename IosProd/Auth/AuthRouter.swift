import UIKit

class AuthRouter: AuthRoutable {
    weak var viewController: UIViewController?
    
    func navigateToServices() {
        let servicesVC = ServicesViewController()
        viewController?.navigationController?.pushViewController(servicesVC, animated: true)
    }
    
    func navigateToPasswordRecovery() {
        let passwordRecoveryVC = PasswordRecoveryViewController()
        viewController?.navigationController?.pushViewController(passwordRecoveryVC, animated: true)
    }
}
