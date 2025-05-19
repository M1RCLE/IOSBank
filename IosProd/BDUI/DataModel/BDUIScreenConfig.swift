import Foundation
import UIKit

/// Represents a configuration for a BDUI screen
struct BDUIScreenConfig {
    /// Base endpoint URL for fetching the UI configuration
    let endpoint: String
    
    /// Storage key for the alfa-itmo.ru server
    let storageKey: String?
    
    /// Additional parameters to include in the request
    let parameters: [String: String]?
    
    /// Navigation title for the screen
    let navigationTitle: String?
    
    /// Navigation type (push or present)
    let navigationType: BDUINavigationType
    
    /// Modal presentation style (used only when navigationType is .present)
    let presentationStyle: UIModalPresentationStyle
    
    /// Initialize a new BDUI screen configuration
    /// - Parameters:
    ///   - endpoint: Base endpoint URL (default is alfa-itmo.ru storage API)
    ///   - storageKey: Optional storage key for the alfa-itmo.ru server
    ///   - parameters: Optional additional parameters
    ///   - navigationTitle: Optional title for the navigation bar
    ///   - navigationType: How to navigate to the screen (default is .push)
    ///   - presentationStyle: Modal presentation style (default is .pageSheet)
    init(
        endpoint: String = "https://alfa-itmo.ru/server/v1/storage/",
        storageKey: String? = nil,
        parameters: [String: String]? = nil,
        navigationTitle: String? = nil,
        navigationType: BDUINavigationType = .push,
        presentationStyle: UIModalPresentationStyle = .pageSheet
    ) {
        self.endpoint = endpoint
        self.storageKey = storageKey
        self.parameters = parameters
        self.navigationTitle = navigationTitle
        self.navigationType = navigationType
        self.presentationStyle = presentationStyle
    }
}

// MARK: - Predefined Configurations

extension BDUIScreenConfig {
    /// Creates a configuration for the alfa-itmo.ru storage API
    static func storage(
        key: String,
        title: String? = nil,
        navigationType: BDUINavigationType = .push
    ) -> BDUIScreenConfig {
        return BDUIScreenConfig(
            endpoint: "https://alfa-itmo.ru/server/v1/storage/",
            storageKey: key,
            navigationTitle: title,
            navigationType: navigationType
        )
    }
    
    /// Creates a configuration for a custom endpoint
    static func custom(
        endpoint: String,
        parameters: [String: String]? = nil,
        title: String? = nil,
        navigationType: BDUINavigationType = .push
    ) -> BDUIScreenConfig {
        return BDUIScreenConfig(
            endpoint: endpoint,
            parameters: parameters,
            navigationTitle: title,
            navigationType: navigationType
        )
    }
}

// MARK: - Feature Specific Configurations

extension BDUIScreenConfig {
    /// Example feature-specific configuration for a product details screen
    static func productDetails(productId: String) -> BDUIScreenConfig {
        return .storage(
            key: "product_details",
            title: "Product Details",
            navigationType: .push
        )
    }
    
    /// Example feature-specific configuration for a settings screen
    static func settings() -> BDUIScreenConfig {
        return .storage(
            key: "settings",
            title: "Settings",
            navigationType: .present
        )
    }
    
    /// Example feature-specific configuration for a complex content screen
    static func complexContent() -> BDUIScreenConfig {
        return .storage(
            key: "complex_content",
            title: "Content",
            navigationType: .push
        )
    }
} 