import UIKit

class SettingsRouter: SettingsRoutable {
    weak var viewController: UIViewController?
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showConfirmationAlert(title: String, message: String, confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let confirmAlertAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            confirmAction()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAlertAction)
        
        viewController?.present(alert, animated: true)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
}
