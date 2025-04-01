protocol AnyPresenter {
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
    var router: AnyRouter? { get set }
}
