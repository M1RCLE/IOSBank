import UIKit

class UserRouter: UserRoutable {
    weak var viewController: UIViewController?
    
    func navigateToAccountDetail(with account: BankAccount) {
        let alert = UIAlertController(
            title: "Account Details",
            message: "Account ID: \(account.id)\nType: \(account.accountType.rawValue)\nBalance: \(account.balance)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        viewController?.present(alert, animated: true)
    }
    
    func navigateToTransactions() {
        // TODO: здесь будет переход на страницу транзакций
    }
    
    func navigateToSettings() {
        // TODO: будущем здесь будет переход на страницу настроек
    }
}
