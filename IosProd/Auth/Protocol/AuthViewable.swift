protocol AuthViewable: AnyObject {
    func displayErrorMessage(_ message: String)
    func showLoadingState(_ isLoading: Bool)
}
