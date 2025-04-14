protocol UserRoutable: AnyObject {
    func navigateToAccountDetail(with account: BankAccount)
    func navigateToTransactions()
    func navigateToSettings()
}
