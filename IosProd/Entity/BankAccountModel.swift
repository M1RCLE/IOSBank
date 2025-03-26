import Foundation

enum AccountType: String, Codable {
    case credit
    case debit
}

struct BankAccount {
    let id: String
    let accountType: AccountType
    let creationDate: Date
    let balance: Double
}
