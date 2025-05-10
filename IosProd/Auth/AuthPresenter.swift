class AuthPresenter: AuthPresentable {
    weak var view: AuthViewable?
    var interactor: AuthInteractable?
    var router: AuthRoutable?
    
    func loginButtonTapped(username: String, password: String) {
        view?.showLoadingState(true)
        interactor?.validateCredentials(username: username, password: password)
    }
    
    func forgotPasswordTapped() {
        router?.navigateToPasswordRecovery()
    }
    
    func validateEmail(_ email: String?) {
        let isValid = interactor?.isValidEmail(email) ?? false
        view?.updateEmailFieldValidation(isValid: isValid)
    }
        
    func validatePassword(_ password: String?) {
        let isValid = interactor?.isValidPassword(password) ?? false
        view?.updatePasswordFieldValidation(isValid: isValid)
    }
    
    func handleError(_ error: AuthError) {
        view?.showLoadingState(false)
        view?.displayErrorMessage(error.rawValue)
    }
    
    func authSuccess() {
        view?.showLoadingState(false)
        router?.navigateToServices()
    }
}
