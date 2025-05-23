import UIKit

protocol BDUIViewProtocol: AnyObject {
    var presenter: BDUIPresenterProtocol? { get set }
    
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func renderUI(with element: BDUIElement)
} 