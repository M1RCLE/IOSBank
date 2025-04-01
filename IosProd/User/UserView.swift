protocol UserViewProtocol: AnyObject {
    func showAccounts(_ accounts: [BankAccount])
    func showTransactionHistory(_ transactions: [Transaction])
    func showLoading()
    func hideLoading()
}
