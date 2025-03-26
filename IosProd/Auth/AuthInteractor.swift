protocol AuthInteractorProtocol {
    func login(username: String, password: String)
    func recoverPassword(for email: String)
}
