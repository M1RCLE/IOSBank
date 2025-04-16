import Foundation

class ServicesInteractor: ServicesInteractable {
    weak var presenter: ServicesPresentable?
    private let service = NetworkService.shared
    
    private let productsEndpoint = "https://dummyjson.com/products"
    
    func fetchProducts() {
        NetworkService.shared.request(endpoint: productsEndpoint) { (result: Result<ProductsResponse, NetworkError>) in
            switch result {
            case .success(let products):
                self.presenter?.didFetchProducts(products.products)
            case .failure(let error):
                self.presenter?.didFailFetchingProducts(with: error.localizedDescription)
            }
        }
    }
}
