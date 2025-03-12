struct BankAccount {
    private let id: String
    private let accountType: AccountType
    private let creationDate: Date
    private let balance: Double
}

enum AccountType {
    case credit
    case debit
}
