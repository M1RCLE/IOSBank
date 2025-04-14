import Foundation

struct Product: Codable {
    let id: String
    let name: String
    let description: String
    let category: String
    let interestRate: Double?
    let monthlyFee: Double?
    let isPromoted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case category
        case interestRate = "interest_rate"
        case monthlyFee = "monthly_fee"
        case isPromoted = "is_promoted"
    }
}

struct ProductsResponse: Codable {
    let products: [Product]
}
