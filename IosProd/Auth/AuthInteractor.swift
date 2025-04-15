import UIKit

class AuthInteractor: AuthInteractable {
    weak var presenter: AuthPresentable?
    var networkService: NetworkService?
    
    private func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        return email.contains("@") && email.contains(".")
    }
    
    private func isValidPassword(_ password: String?) -> Bool {
        guard let password = password else { return false }
        return password.count >= 6
    }
    
    func validateCredentials(username: String?, password: String?) {
        guard isValidEmail(username) else {
            presenter?.handleError(.invalidEmail)
            return
        }
        
        guard isValidPassword(password) else {
            presenter?.handleError(.invalidPassword)
            return
        }
        
        networkService?.authenticate(username: username!, password: password!) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isAuthenticated):
                    if isAuthenticated {
                        self?.presenter?.authSuccess()
                    } else {
                        self?.presenter?.handleError(.invalidCredentials)
                    }
                case .failure(_):
                    self?.presenter?.handleError(.invalidCredentials)
                }
            }
        }
    }
}
