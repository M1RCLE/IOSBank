protocol AuthViewProtocol: AnyObject {
    func showError(_ message: String)
    func navigateToMainServices()
    func showPasswordRecoveryOption()
}
