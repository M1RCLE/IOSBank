import UIKit

protocol BDUIPresenterProtocol: AnyObject {
    var view: BDUIViewProtocol? { get set }
    var interactor: BDUIInteractorInputProtocol? { get set }
    var router: BDUIRouterProtocol? { get set }
    
    func viewDidLoad()
    func handleAction(_ action: BDUIAction, from sourceView: UIView)
} 