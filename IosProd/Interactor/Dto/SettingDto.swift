import Foundation

struct SettingsDTO: Codable {
    struct AppSettings: Codable {
        let isDarkModeEnabled: Bool
        let isNotificationsEnabled: Bool
        let language: String
        let currencyCode: String
        
        init(
            isDarkModeEnabled: Bool = false,
            isNotificationsEnabled: Bool = true,
            language: String = "en",
            currencyCode: String = "USD"
        ) {
            self.isDarkModeEnabled = isDarkModeEnabled
            self.isNotificationsEnabled = isNotificationsEnabled
            self.language = language
            self.currencyCode = currencyCode
        }
    }
    
    struct UserPreferences: Codable {
        var receiveEmailNotifications: Bool
        var receivePushNotifications: Bool
        var defaultTransactionCategory: String?
        var biometricLoginEnabled: Bool
        
        init(
            receiveEmailNotifications: Bool = true,
            receivePushNotifications: Bool = true,
            defaultTransactionCategory: String? = nil,
            biometricLoginEnabled: Bool = false
        ) {
            self.receiveEmailNotifications = receiveEmailNotifications
            self.receivePushNotifications = receivePushNotifications
            self.defaultTransactionCategory = defaultTransactionCategory
            self.biometricLoginEnabled = biometricLoginEnabled
        }
    }
    
    var appSettings: AppSettings
    var userPreferences: UserPreferences
    
    init(
        appSettings: AppSettings = .init(),
        userPreferences: UserPreferences = .init()
    ) {
        self.appSettings = appSettings
        self.userPreferences = userPreferences
    }
}

extension SettingsDTO {
    func toModel() -> SettingsModel {
        return SettingsModel(
            appSettings: .init(
                isDarkModeEnabled: appSettings.isDarkModeEnabled,
                isNotificationsEnabled: appSettings.isNotificationsEnabled,
                language: appSettings.language,
                currencyCode: appSettings.currencyCode
            ),
            userPreferences: .init(
                receiveEmailNotifications: userPreferences.receiveEmailNotifications,
                receivePushNotifications: userPreferences.receivePushNotifications,
                defaultTransactionCategory: userPreferences.defaultTransactionCategory,
                biometricLoginEnabled: userPreferences.biometricLoginEnabled
            )
        )
    }
    
    static func fromModel(_ model: SettingsModel) -> SettingsDTO {
        return SettingsDTO(
            appSettings: .init(
                isDarkModeEnabled: model.appSettings.isDarkModeEnabled,
                isNotificationsEnabled: model.appSettings.isNotificationsEnabled,
                language: model.appSettings.language,
                currencyCode: model.appSettings.currencyCode
            ),
            userPreferences: .init(
                receiveEmailNotifications: model.userPreferences.receiveEmailNotifications,
                receivePushNotifications: model.userPreferences.receivePushNotifications,
                defaultTransactionCategory: model.userPreferences.defaultTransactionCategory,
                biometricLoginEnabled: model.userPreferences.biometricLoginEnabled
            )
        )
    }
}
