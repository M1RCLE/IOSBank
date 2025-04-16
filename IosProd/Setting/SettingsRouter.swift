import UIKit

class SettingsRouter: SettingsRouterProtocol {
    weak var viewController: UIViewController?
    
    func dismissSettings() {
        viewController?.navigationController?.popViewController(animated: true)
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
