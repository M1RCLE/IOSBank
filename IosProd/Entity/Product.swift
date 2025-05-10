import Foundation

struct Product : Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let imageUrl: String?
    
    init(id: Int, title: String, description: String, category: String, imageUrl: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.imageUrl = imageUrl
    }
}
