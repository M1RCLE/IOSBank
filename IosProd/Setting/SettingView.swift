protocol SettingsViewProtocol: AnyObject {
    func displaySettings(_ settings: SettingsModel)
    func displayError(_ error: Error)
    func updateSettingValue(for settingKey: String, newValue: Any)
}
