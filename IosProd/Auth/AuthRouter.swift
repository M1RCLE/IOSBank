import UIKit

class AuthRouter: AuthRoutable {
    weak var viewController: UIViewController?
    
    func navigateToServices() {
        let servicesVC = ServicesBuilder.build()
        viewController?.navigationController?.pushViewController(servicesVC, animated: true)
    }
    
    func navigateToPasswordRecovery() {
        let passwordRecoveryVC = PasswordRecoveryBuilder.build()
        viewController?.navigationController?.pushViewController(passwordRecoveryVC, animated: true)
    }
}
