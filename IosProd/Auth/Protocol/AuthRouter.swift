protocol AuthRouterProtocol: AnyObject {
    func navigateToServices() -> AuthViewProtocol
    func navigateToPasswordRecovery() -> AuthViewProtocol
}
