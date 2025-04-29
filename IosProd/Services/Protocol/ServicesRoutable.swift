protocol ServicesRoutable: AnyObject {
    func navigateToProductDetails(product: ProductDTO)
    func showErrorAlert(message: String)
    func navigateToSettings()
}
