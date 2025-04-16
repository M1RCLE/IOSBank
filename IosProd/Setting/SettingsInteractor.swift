import Foundation

class SettingsInteractor: SettingsInteractorInputProtocol {
    weak var presenter: SettingsPresenterProtocol?
    private let userDefaults = UserDefaults.standard
    
    private var settings: [Setting] = []
    private let defaultSettings: [Setting] = [
        Setting(key: "notifications", title: "Enable Notifications", value: true, type: .toggle),
        Setting(key: "darkMode", title: "Dark Mode", value: false, type: .toggle),
        Setting(key: "language", title: "Language", value: "English", type: .selection, options: ["English", "Spanish", "French", "German"]),
        Setting(key: "fontSize", title: "Font Size", value: "Medium", type: .selection, options: ["Small", "Medium", "Large"])
    ]
    
    func fetchSettings() {
        // Initialize settings with defaults or load from UserDefaults
        settings = defaultSettings.map { setting in
            var updatedSetting = setting
            if let savedValue = userDefaults.object(forKey: setting.key) {
                updatedSetting.value = savedValue
            }
            return updatedSetting
        }
        
        // Create settings model to pass to presenter
        let settingsModel = SettingsModel(settings: settings)
        presenter?.didFetchSettings(settingsModel)
    }
    
    func updateSetting(key: String, value: Any) {
        // Update in UserDefaults
        userDefaults.set(value, forKey: key)
        
        // Update in local array
        if let index = settings.firstIndex(where: { $0.key == key }) {
            settings[index].value = value
        }
        
        // Notify presenter
        presenter?.didUpdateSetting(key: key, value: value)
    }
    
    func resetToDefaultSettings() {
        // Reset all settings to default values
        for setting in defaultSettings {
            userDefaults.set(setting.value, forKey: setting.key)
        }
        
        // Reset local settings array
        settings = defaultSettings
        
        // Notify presenter
        let settingsModel = SettingsModel(settings: settings)
        presenter?.didResetSettings(settingsModel)
    }
}
