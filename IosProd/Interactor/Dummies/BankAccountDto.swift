struct BankAccountDto: AnyObject {
    private let accountType: AccountType
    private let creationDate: Date
    private let balance: Double
}

enum AccountType {
    case credit
    case debit
}
