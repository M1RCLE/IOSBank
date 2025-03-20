protocol UserPresenterProtocol {
    
    
    func loadUserBankAccounts()
    func loadTransactionHistory()
    func transferMoney(from: String, to: String, amount: Double)
}
