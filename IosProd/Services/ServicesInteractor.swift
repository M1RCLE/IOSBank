import Foundation

class ServicesInteractor: ServicesInteractable {
    weak var presenter: ServicesPresentable?
    private let service = NetworkService.shared
    
    private let productsEndpoint = "https://my-json-server.typicode.com/typicode/demo/posts"
    
    func fetchProducts() {
        NetworkService.shared.request(endpoint: productsEndpoint) { [weak self] (result: Result<[Product], NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                self.presenter?.didFetchProducts(products)
            case .failure(let error):
                self.presenter?.didFailFetchingProducts(with: error.localizedDescription)
            }
        }
    }
}
