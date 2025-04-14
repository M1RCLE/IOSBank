protocol UserPresentable: AnyObject {
    func viewDidLoad()
    func settingsTapped()
    func transactionsTapped()
    func didSelectAccount(at index: Int)
    func handleError(_ error: BankNetworkError)
    func accountsLoaded(_ accounts: [BankAccount])
    func userLoaded(_ user: User)
}
