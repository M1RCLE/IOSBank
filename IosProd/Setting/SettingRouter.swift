protocol SettingsRouterProtocol: AnyRouter {
    static func createModule() -> UIViewController
    
    func dismissSettings()
    func showErrorAlert(message: String)
}
