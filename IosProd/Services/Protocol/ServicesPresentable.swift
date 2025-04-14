protocol ServicesPresentable: AnyObject {
    func viewDidLoad()
    func didSelectProduct(at index: Int)
    func refreshData()
    func didFetchProducts(_ products: [Product])
    func didFailFetchingProducts(with error: String)
}
