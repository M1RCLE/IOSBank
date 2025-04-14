import Foundation

struct ProductDTO: Codable {
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
    
    func toModel() -> Product {
        return Product(
            id: id,
            name: name,
            description: description,
            category: category,
            interestRate: interestRate,
            monthlyFee: monthlyFee,
            isPromoted: isPromoted
        )
    }
    
    static func fromModel(_ model: Product) -> ProductDTO {
        return ProductDTO(
            id: model.id,
            name: model.name,
            description: model.description,
            category: model.category,
            interestRate: model.interestRate,
            monthlyFee: model.monthlyFee,
            isPromoted: model.isPromoted
        )
    }
}

struct ProductsResponseDTO: Codable {
    let products: [ProductDTO]
    
    func toModel() -> [Product] {
        return products.map { $0.toModel() }
    }
}
