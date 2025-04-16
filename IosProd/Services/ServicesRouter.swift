import UIKit

class ServicesRouter: ServicesRoutable {
    weak var viewController: UIViewController?
    
    func navigateToProductDetails(product: Product) {
        let alert = UIAlertController(
            title: product.title,
            message: product.description,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
    
    func navigateToSettings() {
        let settingsVC = SettingsBuilder.build()
        viewController?.navigationController?.pushViewController(settingsVC, animated: true)
    }
}
