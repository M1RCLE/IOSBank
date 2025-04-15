import UIKit

class AuthRouter: AuthRoutable {
    weak var viewController: UIViewController?
    
    func navigateToServices() {
        DispatchQueue.main.async { [weak self] in
            let servicesVC = ServicesBuilder.build()
            if let navController = self?.viewController?.navigationController {
                print("Navigation controller exists, pushing services VC")
                navController.pushViewController(servicesVC, animated: true)
            } else {
                print("Navigation controller is nil!")
            }
        }
    }
    
    func navigateToPasswordRecovery() {
        let passwordRecoveryVC = PasswordRecoveryBuilder.build()
        viewController?.navigationController?.pushViewController(passwordRecoveryVC, animated: true)
    }
}
