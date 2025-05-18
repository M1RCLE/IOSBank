public protocol BDUIActionHandlerProtocol {
    func navigate(to route: String, parameters: [String: Any]?)
    func reload(viewId: String?)
    func dismiss(animated: Bool)
    func handleCustomAction(name: String, payload: [String: Any]?)
}
