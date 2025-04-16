protocol AuthViewable: AnyObject {
    func updateEmailFieldValidation(isValid: Bool)
    func updatePasswordFieldValidation(isValid: Bool)
    func displayErrorMessage(_ message: String)
    func showLoadingState(_ isLoading: Bool)
}
