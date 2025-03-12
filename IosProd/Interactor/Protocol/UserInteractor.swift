protocol UserInteractorProtocol: AnyObject {
    func fetchUserAccounts()
    func fetchTransactionHistory()
    func transferMoney(from: String, to: String, amount: Double)
}
