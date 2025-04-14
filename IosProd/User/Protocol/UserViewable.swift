protocol UserViewable: AnyObject {
    func showLoadingState(_ isLoading: Bool)
    func displayAccounts(_ accounts: [AccountViewModel])
    func displayErrorMessage(_ message: String)
    func displayUsername(_ name: String)
}
