import Foundation

struct ProductDTO: Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case thumbnail
    }
    
    func toModel() -> Product {
        return Product(
            id: id,
            title: title,
            description: description,
            category: category,
            imageUrl: thumbnail
        )
    }
    
    static func fromModel(_ model: Product) -> ProductDTO {
        return ProductDTO(
            id: model.id,
            title: model.title,
            description: model.description,
            category: model.category,
            thumbnail: model.imageUrl
        )
    }
}

struct ProductsResponse: Codable {
    let products: [ProductDTO]
    
    func toModel() -> [Product] {
        return products.map { $0.toModel() }
    }
}
