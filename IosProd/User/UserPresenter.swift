protocol UserPresenterProtocol: AnyObject {
    func showTransactionsPressed()
    func tarnsferMoneyPressed()
    func infromationAboutnMoneyTransactionEntered(from: String, to: String, amount: Double)
}
