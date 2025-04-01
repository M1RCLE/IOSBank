protocol UserInteractorProtocol: AnyObject {
    func fetchUserAccounts(with result: Result<[User], Error>)
    func fetchTransactionHistory(with result: Result<[Transaction], Error>)
    func transferMoney(from: String, to: String, amount: Double)
}
