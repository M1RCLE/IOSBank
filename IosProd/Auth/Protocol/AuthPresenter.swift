protocol AuthPresenterProtocol: AnyObject {
    func loginButtonTapped(username: String, password: String)
    func forgotPasswordTaped(email: String)
}
