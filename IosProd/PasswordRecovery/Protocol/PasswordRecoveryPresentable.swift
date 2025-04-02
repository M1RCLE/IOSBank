protocol PasswordRecoveryPresentable: AnyObject {
    func didEnterEmail(_ email: String)
    func recoveryRequestSucceeded()
    func handleError(_ error: PasswordRecoveryError)
}
