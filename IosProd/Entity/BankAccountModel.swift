import Foundation

enum AccountType {
    case credit
    case debit
}

struct BankAccount {
    private let id: String
    private let accountType: AccountType
    private let creationDate: Date
    private let balance: Double
}
