protocol AuthInteractorProtocol: AnyObject {
    func validateCredentials(username: String?, password: String?)
    func recoverPassword(for email: String?)
}
