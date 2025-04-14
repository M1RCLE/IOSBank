class ServicesBuilder {
    static func build() -> ServicesViewController {
        let view = ServicesViewController()
        let presenter = ServicesPresenter()
        let interactor = ServicesInteractor()
        let router = ServicesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
