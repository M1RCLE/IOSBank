import UIKit

struct SettingsSection {
    let title: String
    var rows: [SettingsRow]
}

protocol SettingsRow {}

struct SwitchSettingsRow: SettingsRow {
    let title: String
    var isOn: Bool
    let action: (Bool) -> Void
}

struct ValueSettingsRow: SettingsRow {
    let title: String
    var value: String
    let options: [String]
    let action: (String) -> Void
}

struct ButtonSettingsRow: SettingsRow {
    let title: String
    let buttonTitle: String
    let buttonStyle: UIAlertAction.Style
    let action: () -> Void
}

class SettingsViewController: UIViewController, SettingsViewable {
    var presenter: SettingsPresentable?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchCell")
        tableView.register(ValueTableViewCell.self, forCellReuseIdentifier: "ValueCell")
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "ButtonCell")
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var sections: [SettingsSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Settings"
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        presenter?.navigateBack()
    }
    
    func showLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isLoading {
                self?.loadingIndicator.startAnimating()
                self?.tableView.isHidden = true
            } else {
                self?.loadingIndicator.stopAnimating()
                self?.tableView.isHidden = false
            }
        }
    }
    
    func updateSettings(_ settings: SettingsModel) {
        configureSettingsSections(with: settings)
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func configureSettingsSections(with settings: SettingsModel) {
        sections = [
            // App Appearance Section
            SettingsSection(
                title: "Appearance",
                rows: [
                    SwitchSettingsRow(
                        title: "Dark Mode",
                        isOn: settings.appSettings.isDarkModeEnabled,
                        action: { [weak self] isOn in
                            self?.presenter?.toggleDarkMode(isEnabled: isOn)
                        }
                    ),
                    ValueSettingsRow(
                        title: "Language",
                        value: settings.appSettings.language,
                        options: ["en", "es", "fr", "de", "ru"],
                        action: { [weak self] value in
                            self?.presenter?.changeLanguage(to: value)
                        }
                    ),
                    ValueSettingsRow(
                        title: "Currency",
                        value: settings.appSettings.currencyCode,
                        options: ["USD", "EUR", "GBP", "JPY", "CNY"],
                        action: { [weak self] value in
                            self?.presenter?.changeCurrency(to: value)
                        }
                    )
                ]
            ),
            // Notifications Section
            SettingsSection(
                title: "Notifications",
                rows: [
                    SwitchSettingsRow(
                        title: "Enable Notifications",
                        isOn: settings.appSettings.isNotificationsEnabled,
                        action: { [weak self] isOn in
                            self?.presenter?.toggleNotifications(isEnabled: isOn)
                        }
                    ),
                    SwitchSettingsRow(
                        title: "Email Notifications",
                        isOn: settings.userPreferences.receiveEmailNotifications,
                        action: { [weak self] isOn in
                            self?.presenter?.toggleEmailNotifications(isEnabled: isOn)
                        }
                    ),
                    SwitchSettingsRow(
                        title: "Push Notifications",
                        isOn: settings.userPreferences.receivePushNotifications,
                        action: { [weak self] isOn in
                            self?.presenter?.togglePushNotifications(isEnabled: isOn)
                        }
                    )
                ]
            ),
            // Security Section
            SettingsSection(
                title: "Security",
                rows: [
                    SwitchSettingsRow(
                        title: "Biometric Login",
                        isOn: settings.userPreferences.biometricLoginEnabled,
                        action: { [weak self] isOn in
                            self?.presenter?.toggleBiometricLogin(isEnabled: isOn)
                        }
                    )
                ]
            ),
            // Actions Section
            SettingsSection(
                title: "Actions",
                rows: [
                    ButtonSettingsRow(
                        title: "Reset to Default Settings",
                        buttonTitle: "Reset",
                        buttonStyle: .destructive,
                        action: { [weak self] in
                            self?.presenter?.resetToDefaults()
                        }
                    )
                ]
            )
        ]
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        
        if let switchRow = row as? SwitchSettingsRow {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchTableViewCell
            cell.configure(title: switchRow.title, isOn: switchRow.isOn) { isOn in
                switchRow.action(isOn)
            }
            return cell
        } else if let valueRow = row as? ValueSettingsRow {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ValueCell", for: indexPath) as! ValueTableViewCell
            cell.configure(title: valueRow.title, value: valueRow.value)
            return cell
        } else if let buttonRow = row as? ButtonSettingsRow {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
            cell.configure(title: buttonRow.title, buttonTitle: buttonRow.buttonTitle, style: buttonRow.buttonStyle) {
                buttonRow.action()
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = sections[indexPath.section].rows[indexPath.row]
        if let valueRow = row as? ValueSettingsRow {
            let alert = UIAlertController(title: "Select \(valueRow.title)", message: nil, preferredStyle: .actionSheet)
            
            for option in valueRow.options {
                let action = UIAlertAction(title: option, style: .default) { [weak self] _ in
                    valueRow.action(option)
                    
                    var updatedRow = valueRow
                    updatedRow.value = option

                    self?.sections[indexPath.section].rows[indexPath.row] = updatedRow
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                }
                alert.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    }
}
