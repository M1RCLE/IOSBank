protocol AuthPresentable: AnyObject {
    func loginButtonTapped(username: String, password: String)
    func forgotPasswordTapped(email: String)
    func handleError(_ error: AuthError)
    func authSuccess()
    func passwordRecoveryInitiated()
}
