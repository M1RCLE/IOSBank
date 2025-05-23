import UIKit

final class BDUIPresenter: BDUIPresenterProtocol, BDUIInteractorOutputProtocol {
    weak var view: BDUIViewProtocol?
    var interactor: BDUIInteractorInputProtocol?
    var router: BDUIRouterProtocol?
    
    private let config: BDUIScreenConfig?
    private let jsonString: String?
    
    init(with config: BDUIScreenConfig) {
        self.config = config
        self.jsonString = nil
    }
    
    init(with jsonString: String, navigationTitle: String? = nil) {
        self.jsonString = jsonString
        self.config = nil
    }
    
    // MARK: - BDUIPresenterProtocol
    
    func viewDidLoad() {
        if let jsonString = jsonString {
            view?.showLoading()
            interactor?.parseUI(from: jsonString)
        } else if let config = config {
            view?.showLoading()
            interactor?.fetchUI(
                from: config.endpoint,
                storageKey: config.storageKey,
                username: config.username,
                password: config.password
            )
        }
    }
    
    func handleAction(_ action: BDUIAction, from sourceView: UIView) {
        switch action.type {
        case .navigate:
            if let route = action.payload?["route"]?.stringValue,
               let parameters = action.payload?["parameters"]?.dictionaryValue {
                router?.navigate(to: route, with: parameters)
            }
        case .reload:
            viewDidLoad()
        case .dismiss:
            let animated = action.payload?["animated"]?.boolValue ?? true
            router?.dismissView(animated: animated)
        case .custom:
            // Handle custom actions if needed
            if let name = action.payload?["name"]?.stringValue {
                print("Custom action: \(name)")
            }
        }
    }
    
    // MARK: - BDUIInteractorOutputProtocol
    
    func didFetchUI(element: BDUIElement) {
        view?.hideLoading()
        view?.renderUI(with: element)
    }
    
    func didFailFetchingUI(with error: Error) {
        view?.hideLoading()
        view?.showError(message: "Failed to load UI: \(error.localizedDescription)")
    }
} 