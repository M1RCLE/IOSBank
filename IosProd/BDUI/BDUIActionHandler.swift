class BDUIActionHandler: BDUIActionHandlerProtocol {
    func navigate(to route: String, parameters: [String: Any]?) {
        print("Navigating to \(route) with parameters: \(parameters ?? [:])")
    }
    
    func reload(viewId: String?) {
        print("Reloading view with ID: \(viewId ?? "all")")
    }
    
    func dismiss(animated: Bool) {
        print("Dismissing view with animation: \(animated)")
    }
    
    func handleCustomAction(name: String, payload: [String: Any]?) {
        print("Handling custom action: \(name) with payload: \(payload ?? [:])")
    }
}
