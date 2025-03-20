protocol TransactionInteractor {
    func getDetailedInformation(with result: Result<[Transaction], Error>)
}
