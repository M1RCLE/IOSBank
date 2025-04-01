protocol TransactionInteractor: AnyObject {
    func getDetailedInformation(with result: Result<[Transaction], Error>)
}
