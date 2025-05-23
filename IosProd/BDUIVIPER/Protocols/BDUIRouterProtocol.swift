import UIKit

protocol BDUIRouterProtocol: AnyObject {
    static func createModule(
        with config: BDUIScreenConfig
    ) -> UIViewController
    
    static func createModule(
        with jsonString: String, 
        navigationTitle: String?
    ) -> UIViewController
    
    func navigate(to route: String, with parameters: [String: Any]?)
    func dismissView(animated: Bool)
} 