import UIKit

final class BDUIActionHandler: BDUIActionHandlerProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigate(to route: String, parameters: [String: Any]?) {
        // пока без логики навигации
        // трасировка для проверки: print("Navigating to \(route) with parameters: \(parameters ?? [:])")
    }
    
    func reload(viewId: String?) {
        if let viewId = viewId {
            print("Reloading view with ID: \(viewId)")
            NotificationCenter.default.post(name: NSNotification.Name("ReloadView"), object: nil, userInfo: ["viewId": viewId])
        } else {
            print("Reloading entire screen")
            NotificationCenter.default.post(name: NSNotification.Name("ReloadScreen"), object: nil)
        }
    }
    
    func dismiss(animated: Bool) {
        viewController?.dismiss(animated: animated, completion: nil)
    }
    
    func handleCustomAction(name: String, payload: [String: Any]?) {
        // трасировка для проверки: print("action: \(name) with payload: \(payload ?? [:])")
        NotificationCenter.default.post(name: NSNotification.Name(name), object: nil, userInfo: payload)
    }
}
