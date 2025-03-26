protocol SettingsPresenterProtocol: AnyPresenter {
    func viewDidLoad()
    func didChangeSetting(key: String, newValue: Any)
    func didRequestResetToDefaults()
}
