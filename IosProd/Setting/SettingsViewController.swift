import UIKit

class SettingsViewController: UIViewController, SettingsViewProtocol {
    var presenter: SettingsPresenterProtocol?
    private var settings: [Setting] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToggleSettingCell.self, forCellReuseIdentifier: "ToggleSettingCell")
        tableView.register(SelectionSettingCell.self, forCellReuseIdentifier: "SelectionSettingCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var resetButton: UIBarButtonItem = {
        return UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(resetButtonTapped)
        )
    }()
    
    private lazy var closeButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = resetButton
        navigationItem.leftBarButtonItem = closeButton
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func resetButtonTapped() {
        let alert = UIAlertController(
            title: "Reset Settings",
            message: "Are you sure you want to reset all settings to default values?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { [weak self] _ in
            self?.presenter?.didRequestResetToDefaults()
        }))
        
        present(alert, animated: true)
    }
    
    @objc private func closeButtonTapped() {
        presenter?.didTapClose()
    }
    
    // MARK: - SettingsViewProtocol
    
    func displaySettings(_ settings: SettingsModel) {
        self.settings = settings.settings
        tableView.reloadData()
    }
    
    func displayError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateSettingValue(for settingKey: String, newValue: Any) {
        if let index = settings.firstIndex(where: { $0.key == settingKey }) {
            settings[index].value = newValue
            
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.row]
        
        switch setting.type {
        case .toggle:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleSettingCell", for: indexPath) as? ToggleSettingCell else {
                return UITableViewCell()
            }
            cell.configure(with: setting) { [weak self] newValue in
                self?.presenter?.didChangeSetting(key: setting.key, newValue: newValue)
            }
            return cell
            
        case .selection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionSettingCell", for: indexPath) as? SelectionSettingCell else {
                return UITableViewCell()
            }
            cell.configure(with: setting)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let setting = settings[indexPath.row]
        
        if setting.type == .selection, let options = setting.options {
            showSelectionOptionsAlert(for: setting, options: options)
        }
    }
    
    private func showSelectionOptionsAlert(for setting: Setting, options: [String]) {
        let alert = UIAlertController(
            title: setting.title,
            message: "Select an option",
            preferredStyle: .actionSheet
        )
        
        for option in options {
            let action = UIAlertAction(title: option, style: .default) { [weak self] _ in
                self?.presenter?.didChangeSetting(key: setting.key, newValue: option)
            }
            
            // Mark the currently selected option
            if let currentValue = setting.value as? String, currentValue == option {
                action.setValue(true, forKey: "checked")
            }
            
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // For iPad compatibility
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = tableView
            if let cell = tableView.cellForRow(at: IndexPath(row: settings.firstIndex(of: setting) ?? 0, section: 0)) {
                popoverController.sourceRect = cell.frame
            }
        }
        
        present(alert, animated: true)
    }
}

// MARK: - Custom Cell Classes

class ToggleSettingCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let toggleSwitch = UISwitch()
    private var valueChangedHandler: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)
        
        toggleSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: toggleSwitch.leadingAnchor, constant: -8),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with setting: Setting, valueChanged: @escaping (Bool) -> Void) {
        titleLabel.text = setting.title
        
        if let isOn = setting.value as? Bool {
            toggleSwitch.isOn = isOn
        }
        
        self.valueChangedHandler = valueChanged
    }
    
    @objc private func switchValueChanged() {
        valueChangedHandler?(toggleSwitch.isOn)
    }
}

class SelectionSettingCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        valueLabel.textColor = .gray
        valueLabel.textAlignment = .right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8)
        ])
    }
    
    func configure(with setting: Setting) {
        titleLabel.text = setting.title
        valueLabel.text = setting.value as? String
    }
}
