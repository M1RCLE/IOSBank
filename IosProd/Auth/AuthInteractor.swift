class AuthInteractor: AuthInteractable {
    weak var presenter: AuthPresentable?
    
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
        
        if username == "test@example.com" && password == "123456" {
            presenter?.authSuccess()
        } else {
            presenter?.handleError(.invalidCredentials)
        }
    }
}
