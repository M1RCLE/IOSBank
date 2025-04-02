class AuthPresenter: AuthPresentable {
    weak var view: AuthViewable?
    var interactor: AuthInteractable?
    var router: AuthRoutable?
    
    func loginButtonTapped(username: String, password: String) {
        view?.showLoadingState(true)
        interactor?.validateCredentials(username: username, password: password)
    }
    
    func forgotPasswordTapped(email: String) {
        interactor?.recoverPassword(for: email)
    }
    
    func handleError(_ error: AuthError) {
        view?.showLoadingState(false)
        view?.displayErrorMessage(error.rawValue)
    }
    
    func authSuccess() {
        view?.showLoadingState(false)
        router?.navigateToServices()
    }
    
    func passwordRecoveryInitiated() {
        view?.showPasswordRecoveryScreen()
    }
}
