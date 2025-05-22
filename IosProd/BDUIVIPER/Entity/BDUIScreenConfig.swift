import Foundation
import UIKit

struct BDUIScreenConfig {
    let endpoint: String
    let storageKey: String?
    let parameters: [String: String]?
    let navigationTitle: String?
    let navigationType: BDUINavigationType
    let presentationStyle: UIModalPresentationStyle
    let username: String?
    let password: String?
    
    init(
        endpoint: String = "https://alfa-itmo.ru/server/v1/storage/",
        storageKey: String? = nil,
        parameters: [String: String]? = nil,
        navigationTitle: String? = nil,
        navigationType: BDUINavigationType = .push,
        presentationStyle: UIModalPresentationStyle = .pageSheet,
        username: String? = nil,
        password: String? = nil
    ) {
        self.endpoint = endpoint
        self.storageKey = storageKey
        self.parameters = parameters
        self.navigationTitle = navigationTitle
        self.navigationType = navigationType
        self.presentationStyle = presentationStyle
        self.username = username
        self.password = password
    }
}

extension BDUIScreenConfig {
    static func storage(
        key: String,
        title: String? = nil,
        navigationType: BDUINavigationType = .push,
        username: String? = nil,
        password: String? = nil
    ) -> BDUIScreenConfig {
        return BDUIScreenConfig(
            endpoint: "https://alfa-itmo.ru/server/v1/storage/",
            storageKey: key,
            navigationTitle: title,
            navigationType: navigationType,
            username: username,
            password: password
        )
    }
    
    static func custom(
        endpoint: String,
        parameters: [String: String]? = nil,
        title: String? = nil,
        navigationType: BDUINavigationType = .push,
        username: String? = nil,
        password: String? = nil
    ) -> BDUIScreenConfig {
        return BDUIScreenConfig(
            endpoint: endpoint,
            parameters: parameters,
            navigationTitle: title,
            navigationType: navigationType,
            username: username,
            password: password
        )
    }
}

extension BDUIScreenConfig {
    static func productDetails(productId: String, username: String? = nil, password: String? = nil) -> BDUIScreenConfig {
        return .storage(
            key: "product_details",
            title: "Product Details",
            navigationType: .push,
            username: username,
            password: password
        )
    }
    
    static func settings(username: String? = nil, password: String? = nil) -> BDUIScreenConfig {
        return .storage(
            key: "settings",
            title: "Settings",
            navigationType: .present,
            username: username,
            password: password
        )
    }
    
    static func complexContent(username: String? = nil, password: String? = nil) -> BDUIScreenConfig {
        return .storage(
            key: "complex_content",
            title: "Content",
            navigationType: .push,
            username: username,
            password: password
        )
    }
} 
