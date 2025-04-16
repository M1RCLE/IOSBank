import Foundation

struct ProductViewModel {
    let id: String
    let title: String
    let shortDescription: String
    let category: String
    
    init(from product: Product) {
        self.id = product.id
        self.title = product.title
        self.shortDescription = String(product.description.prefix(100)) + (product.description.count > 100 ? "..." : "")
        self.category = product.category
    }
}
