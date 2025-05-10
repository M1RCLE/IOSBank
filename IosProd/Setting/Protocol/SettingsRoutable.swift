protocol SettingsRoutable: AnyObject {
    func navigateBack()
    func showConfirmationAlert(title: String, message: String, confirmAction: @escaping () -> Void)
    func showErrorAlert(message: String)
}
