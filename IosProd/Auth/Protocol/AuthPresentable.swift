protocol AuthPresentable: AnyObject {
    func loginButtonTapped(username: String, password: String)
    func forgotPasswordTapped()
    func handleError(_ error: AuthError)
    func authSuccess()
}
