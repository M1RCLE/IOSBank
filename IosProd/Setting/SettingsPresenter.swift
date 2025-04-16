import Foundation

class SettingsPresenter: SettingsPresentable {
    weak var view: SettingsViewable?
    var interactor: SettingsInteractable?
    var router: SettingsRoutable?
    
    private var currentSettings: SettingsModel?
    
    func navigateBack() {
        router?.navigateBack()
    }
    
    func viewDidLoad() {
        view?.showLoading(true)
        interactor?.fetchSettings()
    }
    
    func toggleDarkMode(isEnabled: Bool) {
        interactor?.updateSetting(key: "isDarkModeEnabled", value: isEnabled)
    }
    
    func toggleNotifications(isEnabled: Bool) {
        interactor?.updateSetting(key: "isNotificationsEnabled", value: isEnabled)
    }
    
    func changeLanguage(to language: String) {
        interactor?.updateSetting(key: "language", value: language)
    }
    
    func changeCurrency(to currencyCode: String) {
        interactor?.updateSetting(key: "currencyCode", value: currencyCode)
    }
    
    func toggleEmailNotifications(isEnabled: Bool) {
        interactor?.updateSetting(key: "receiveEmailNotifications", value: isEnabled)
    }
    
    func togglePushNotifications(isEnabled: Bool) {
        interactor?.updateSetting(key: "receivePushNotifications", value: isEnabled)
    }
    
    func toggleBiometricLogin(isEnabled: Bool) {
        interactor?.updateSetting(key: "biometricLoginEnabled", value: isEnabled)
    }
    
    func resetToDefaults() {
        router?.showConfirmationAlert(
            title: "Reset Settings",
            message: "Are you sure you want to reset all settings to default values?",
            confirmAction: { [weak self] in
                self?.interactor?.resetToDefaultSettings()
            }
        )
    }
    
    func didFetchSettings(_ settings: SettingsModel) {
        self.currentSettings = settings
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoading(false)
            self?.view?.updateSettings(settings)
        }
    }
    
    func didUpdateSetting(key: String, value: Any, success: Bool) {
        if success {
            if let settings = currentSettings {
                DispatchQueue.main.async { [weak self] in
                    self?.view?.updateSettings(settings)
                }
            }
        } else {
            didFailOperation(with: "Failed to update setting: \(key)")
        }
    }
    
    func didFailOperation(with error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoading(false)
            self?.view?.showError(error)
        }
    }
}
