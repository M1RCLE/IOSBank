import Foundation

struct ProductDTO: Codable {
    let id: String
    let title: String
    let description: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
    }
    
    func toModel() -> Product {
        return Product(
            id: id,
            title: title,
            description: description,
            category: category
        )
    }
    
    static func fromModel(_ model: Product) -> ProductDTO {
        return ProductDTO(
            id: model.id,
            title: model.title,
            description: model.description,
            category: model.category
        )
    }
}

struct ProductsResponseDTO: Codable {
    let products: [ProductDTO]
    
    func toModel() -> [Product] {
        return products.map { $0.toModel() }
    }
}
