import UIKit

class PasswordRecoveryRouter: PasswordRecoveryRoutable {
    weak var viewController: UIViewController?
    
    func navigateToSuccessScreen() {
//        TODO: implement navigation to success scrin
//        let successVC = PasswordRecoverySuccessViewController()
//        viewController?.navigationController?.pushViewController(successVC, animated: true)
    }
    
    func closeRecoveryFlow() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
