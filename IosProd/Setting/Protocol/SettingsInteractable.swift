protocol SettingsInteractable: AnyObject {
    func fetchSettings()
    func updateSetting(key: String, value: Any)
    func resetToDefaultSettings()
}
