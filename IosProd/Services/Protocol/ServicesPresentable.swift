protocol ServicesPresentable: AnyObject {
    func viewDidLoad()
    func didSelectProduct(at index: Int)
    func refreshData()
    func showSettings()
    func didFetchProducts(_ products: [ProductDTO])
    func didFailFetchingProducts(with error: String)
}
