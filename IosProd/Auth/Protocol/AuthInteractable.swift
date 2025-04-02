protocol AuthInteractable: AnyObject {
    func validateCredentials(username: String?, password: String?)
}
