import Foundation

class SettingsPresenter: SettingsPresenterProtocol {
    weak var view: SettingsViewProtocol?
    var interactor: SettingsInteractorInputProtocol?
    var router: SettingsRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchSettings()
    }
    
    func didChangeSetting(key: String, newValue: Any) {
        interactor?.updateSetting(key: key, value: newValue)
    }
    
    func didRequestResetToDefaults() {
        interactor?.resetToDefaultSettings()
    }
    
    // Callbacks from interactor
    func didFetchSettings(_ settings: SettingsModel) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.displaySettings(settings)
        }
    }
    
    func didUpdateSetting(key: String, value: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.updateSettingValue(for: key, newValue: value)
        }
    }
    
    func didResetSettings(_ settings: SettingsModel) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.displaySettings(settings)
        }
    }
    
    func didEncounterError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.displayError(error)
            self?.router?.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    func didTapClose() {
        router?.dismissSettings()
    }
}
