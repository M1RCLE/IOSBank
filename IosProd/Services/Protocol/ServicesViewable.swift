protocol ServicesViewable: AnyObject {
    func showLoading(_ isLoading: Bool)
    func showProducts(_ products: [ProductViewModel])
    func showError(_ message: String)
}
