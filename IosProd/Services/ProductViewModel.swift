import Foundation

struct ProductViewModel {
    let id: String
    let name: String
    let shortDescription: String
    let category: String
    let details: String
    let isPromoted: Bool
    
    init(from product: Product) {
        self.id = product.id
        self.name = product.name
        self.shortDescription = String(product.description.prefix(100)) + (product.description.count > 100 ? "..." : "")
        self.category = product.category
        
        var detailsText = ""
        if let interestRate = product.interestRate {
            detailsText += "Interest Rate: \(String(format: "%.2f", interestRate))% "
        }
        if let monthlyFee = product.monthlyFee {
            detailsText += "Monthly Fee: $\(String(format: "%.2f", monthlyFee))"
        }
        self.details = detailsText
        
        self.isPromoted = product.isPromoted
    }
}
