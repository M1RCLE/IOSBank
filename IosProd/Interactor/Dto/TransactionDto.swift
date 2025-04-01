import Foundation

struct TransactionDTO: Codable {
    let id: String
    let fromAccount: String
    let toAccount: String
    let amount: Double
    let date: Date
    
    func toModel() -> Transaction {
        return Transaction(
            id: id,
            fromAccount: fromAccount,
            toAccount: toAccount,
            amount: amount,
            date: date
        )
    }
    
    static func fromModel(_ model: Transaction) -> TransactionDTO {
        return TransactionDTO(
            id: model.id,
            fromAccount: model.fromAccount,
            toAccount: model.toAccount,
            amount: model.amount,
            date: model.date
        )
    }
}
