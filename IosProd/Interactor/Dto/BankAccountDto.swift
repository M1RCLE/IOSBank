import Foundation

struct BankAccountDTO: Codable {
    let id: String
    let accountType: AccountType
    let creationDate: Date
    let balance: Double
    
    func toModel() -> BankAccount {
        return BankAccount(
            id: id,
            accountType: accountType,
            creationDate: creationDate,
            balance: balance
        )
    }
    
    static func fromModel(_ model: BankAccount) -> BankAccountDTO {
        return BankAccountDTO(
            id: model.id,
            accountType: model.accountType,
            creationDate: model.creationDate,
            balance: model.balance
        )
    }
}
