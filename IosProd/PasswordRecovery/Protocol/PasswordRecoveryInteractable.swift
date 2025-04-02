protocol PasswordRecoveryInteractable: AnyObject {
    func sendRecoveryRequest(email: String)
}
