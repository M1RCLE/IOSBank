import UIKit

class PasswordRecoveryInteractor: PasswordRecoveryInteractable {
    weak var presenter: PasswordRecoveryPresentable?
    
    func sendRecoveryRequest(email: String) {
        guard isValidEmail(email) else {
            presenter?.handleError(.invalidEmail)
            return
        }
        
        // TODO: think about how will I send request
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}
