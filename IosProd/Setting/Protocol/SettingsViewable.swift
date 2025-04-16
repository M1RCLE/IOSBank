protocol SettingsViewable: AnyObject {
    func showLoading(_ isLoading: Bool)
    func updateSettings(_ settings: SettingsModel)
    func showError(_ message: String)
}
