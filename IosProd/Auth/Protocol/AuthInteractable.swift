protocol AuthInteractable: AnyObject {
    func isValidEmail(_ email: String?) -> Bool
    func isValidPassword(_ password: String?) -> Bool
    func validateCredentials(username: String?, password: String?)
}
