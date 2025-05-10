protocol ServicesViewable: AnyObject {
    func showLoading(_ isLoading: Bool)
    func showProducts(_ products: [EnhancedProductViewModel])
    func showError(_ message: String)
}
