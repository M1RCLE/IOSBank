import UIKit

class ProductDetailsBuilder {
    static func build(with product: ProductDTO) -> ProductDetailsViewController {
        return ProductDetailsViewController(product: product)
    }
}
