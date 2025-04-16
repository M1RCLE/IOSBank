import UIKit

class AuthInteractor: AuthInteractable {
    weak var presenter: AuthPresentable?
    var networkService: NetworkService? = NetworkService.shared
    
    func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        return email.contains("@") && email.contains(".") && email.count > 5
    }
        
    func isValidPassword(_ password: String?) -> Bool {
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
        
        print("About to authenticate with network service...")
            if let service = networkService {
                service.authenticate(username: username!, password: password!) { [weak self] result in
                    print("Authentication result received: \(result)")
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let isAuthenticated):
                            if isAuthenticated {
                                print("Authentication successful, calling authSuccess")
                                self?.presenter?.authSuccess()
                            } else {
                                print("Authentication failed with invalid credentials")
                                self?.presenter?.handleError(.invalidCredentials)
                            }
                        case .failure(let error):
                            print("Authentication failed with error: \(error)")
                            self?.presenter?.handleError(.invalidCredentials)
                        }
                    }
                }
            } else {
                print("Network service is nil!")
            }
    }
}
