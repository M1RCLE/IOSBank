import Foundation

// Input protocol (called by presenter)
protocol BDUIInteractorInputProtocol: AnyObject {
    var presenter: BDUIInteractorOutputProtocol? { get set }
    
    func fetchUI(from endpoint: String, storageKey: String?, username: String?, password: String?)
    func parseUI(from jsonData: Data)
    func parseUI(from jsonString: String)
}

// Output protocol (called by interactor)
protocol BDUIInteractorOutputProtocol: AnyObject {
    func didFetchUI(element: BDUIElement)
    func didFailFetchingUI(with error: Error)
} 