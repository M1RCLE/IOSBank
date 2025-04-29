import Foundation

class ServicesPresenter: ServicesPresentable {
    weak var view: ServicesViewable?
    var interactor: ServicesInteractable?
    var router: ServicesRoutable?
    
    private var products: [ProductDTO] = []
    
    func viewDidLoad() {
        loadProducts()
    }
    
    func didSelectProduct(at index: Int) {
        guard index < products.count else { return }
        router?.navigateToProductDetails(product: products[index])
    }
    
    func refreshData() {
        loadProducts()
    }
    
    func showSettings() {
        router?.navigateToSettings()
    }
    
    private func loadProducts() {
        view?.showLoading(true)
        interactor?.fetchProducts()
    }
    
    func didFetchProducts(_ products: [ProductDTO]) {
        self.products = products
        
        let viewModels = products.map { EnhancedProductViewModel(from: $0) }
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoading(false)
            self?.view?.showProducts(viewModels)
        }
    }
    
    func didFailFetchingProducts(with error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoading(false)
            self?.view?.showError(error)
            self?.router?.showErrorAlert(message: error)
        }
    }
}
