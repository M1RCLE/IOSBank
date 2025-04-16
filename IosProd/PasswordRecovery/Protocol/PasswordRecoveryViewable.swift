protocol PasswordRecoveryViewable: AnyObject {
    func displayError(message: String)
    func showLoading(_ isLoading: Bool)
}
