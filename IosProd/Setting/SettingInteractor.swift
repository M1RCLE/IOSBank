protocol SettingsInteractorInputProtocol: AnyInteractor {
    func fetchSettings()
    func updateSetting(key: String, value: Any)
    func resetToDefaultSettings()
}
