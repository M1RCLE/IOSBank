protocol ServicesRoutable: AnyObject {
    func navigateToProductDetails(product: Product)
    func showErrorAlert(message: String)
    func navigateToSettings()
}
