protocol AuthViewProtocol: AnyObject {
    func displayErrorMessage(_ message: String)
    func showPasswordRecoveryScreen()
    func showLoadingState(_ isLoading: Bool)
}
