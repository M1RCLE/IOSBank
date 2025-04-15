class AuthModuleBuilder {
    static func build() -> AuthViewController {
        let view = AuthViewController()
        let presenter = AuthPresenter()
        let interactor = AuthInteractor()
        let router = AuthRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.networkService = NetworkService.shared
        router.viewController = view
        
        return view
    }
}
