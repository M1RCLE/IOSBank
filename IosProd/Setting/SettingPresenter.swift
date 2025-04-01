protocol SettingsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didChangeSetting(key: String, newValue: Any)
    func didRequestResetToDefaults()
}
