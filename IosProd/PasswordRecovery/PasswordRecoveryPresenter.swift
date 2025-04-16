import UIKit

class PasswordRecoveryPresenter: PasswordRecoveryPresentable {
    weak var view: PasswordRecoveryViewable?
    var interactor: PasswordRecoveryInteractable?
    var router: PasswordRecoveryRoutable?
    
    func didEnterEmail(_ email: String) {
        view?.showLoading(true)
        interactor?.sendRecoveryRequest(email: email)
    }
    
    func recoveryRequestSucceeded() {
        view?.showLoading(false)
        router?.navigateToSuccessScreen()
    }
    
    func handleError(_ error: PasswordRecoveryError) {
        view?.showLoading(false)
        view?.displayError(message: error.description)
    }
}
