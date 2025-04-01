protocol UserRouterProtocol: AnyObject {
    func navigateToMoneyTransfer() -> UserRouterProtocol
    func navigateToTransactionHistory() -> UserRouterProtocol
}
