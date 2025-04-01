import Foundation

struct SettingsModel {
    struct AppSettings {
        var isDarkModeEnabled: Bool
        var isNotificationsEnabled: Bool
        var language: String
        var currencyCode: String
    }
    
    struct UserPreferences {
        var receiveEmailNotifications: Bool
        var receivePushNotifications: Bool
        var defaultTransactionCategory: String?
        var biometricLoginEnabled: Bool
    }
    
    var appSettings: AppSettings
    var userPreferences: UserPreferences
}
