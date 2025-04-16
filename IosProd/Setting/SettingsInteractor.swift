import Foundation

class SettingsInteractor: SettingsInteractable {
    weak var presenter: SettingsPresentable?
    private let userDefaults = UserDefaults.standard
    private let settingsKey = "userSettings"
    
    func fetchSettings() {
        // In a real app, this would fetch from a backend API or local storage
        // For now, I'll use UserDefaults or create default settings if not found
        
        if let savedSettingsData = userDefaults.data(forKey: settingsKey),
           let savedSettingsDTO = try? JSONDecoder().decode(SettingsDTO.self, from: savedSettingsData) {
            let settings = savedSettingsDTO.toModel()
            presenter?.didFetchSettings(settings)
        } else {
            let defaultSettings = createDefaultSettings()
            presenter?.didFetchSettings(defaultSettings)
            saveSettings(defaultSettings)
        }
    }
    
    func updateSetting(key: String, value: Any) {
        guard let settingsData = userDefaults.data(forKey: settingsKey),
              var settings = try? JSONDecoder().decode(SettingsDTO.self, from: settingsData).toModel() else {
            presenter?.didFailOperation(with: "Failed to retrieve settings")
            return
        }
        
        var updated = false
        
        if key == "isDarkModeEnabled", let boolValue = value as? Bool {
            settings.appSettings.isDarkModeEnabled = boolValue
            updated = true
        } else if key == "isNotificationsEnabled", let boolValue = value as? Bool {
            settings.appSettings.isNotificationsEnabled = boolValue
            updated = true
        } else if key == "language", let stringValue = value as? String {
            settings.appSettings.language = stringValue
            updated = true
        } else if key == "currencyCode", let stringValue = value as? String {
            settings.appSettings.currencyCode = stringValue
            updated = true
        }
        else if key == "receiveEmailNotifications", let boolValue = value as? Bool {
            settings.userPreferences.receiveEmailNotifications = boolValue
            updated = true
        } else if key == "receivePushNotifications", let boolValue = value as? Bool {
            settings.userPreferences.receivePushNotifications = boolValue
            updated = true
        } else if key == "defaultTransactionCategory", let stringValue = value as? String {
            settings.userPreferences.defaultTransactionCategory = stringValue
            updated = true
        } else if key == "biometricLoginEnabled", let boolValue = value as? Bool {
            settings.userPreferences.biometricLoginEnabled = boolValue
            updated = true
        }
        
        if updated {
            saveSettings(settings)
            presenter?.didUpdateSetting(key: key, value: value, success: true)
        } else {
            presenter?.didFailOperation(with: "Invalid setting key or value type")
        }
    }
    
    func resetToDefaultSettings() {
        let defaultSettings = createDefaultSettings()
        saveSettings(defaultSettings)
        presenter?.didFetchSettings(defaultSettings)
    }
    
    private func createDefaultSettings() -> SettingsModel {
        return SettingsModel(
            appSettings: .init(
                isDarkModeEnabled: false,
                isNotificationsEnabled: true,
                language: "en",
                currencyCode: "USD"
            ),
            userPreferences: .init(
                receiveEmailNotifications: true,
                receivePushNotifications: true,
                defaultTransactionCategory: nil,
                biometricLoginEnabled: false
            )
        )
    }
    
    private func saveSettings(_ settings: SettingsModel) {
        let settingsDTO = SettingsDTO.fromModel(settings)
        do {
            let encodedData = try JSONEncoder().encode(settingsDTO)
            userDefaults.set(encodedData, forKey: settingsKey)
        } catch {
            presenter?.didFailOperation(with: "Failed to save settings: \(error.localizedDescription)")
        }
    }
}
