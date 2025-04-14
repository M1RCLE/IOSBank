import Foundation

struct AccountViewModel {
    let id: String
    let accountType: String
    let formattedBalance: String
    let formattedDate: String
    
    init(from account: BankAccount) {
        self.id = account.id
        self.accountType = account.accountType.rawValue.capitalized
        self.formattedBalance = String(format: "%.2f $", account.balance)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.formattedDate = dateFormatter.string(from: account.creationDate)
    }
}
