import Foundation

struct Product: Codable {
    let id: String
    let title: String
    let description: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case category = "category"
    }
}

struct ProductsResponse: Codable {
    let products: [Product]
}
