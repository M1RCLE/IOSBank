class PasswordRecoveryBuilder {
    static func build() -> PasswordRecoveryViewController {
        let view = PasswordRecoveryViewController()
        let presenter = PasswordRecoveryPresenter()
        let interactor = PasswordRecoveryInteractor()
        let router = PasswordRecoveryRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
