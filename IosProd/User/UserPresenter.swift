import Foundation

class UserPresenter: UserPresentable {
    weak var view: UserViewable?
    var interactor: UserInteractable?
    var router: UserRoutable?
    
    private var accounts: [BankAccount] = []
    private var user: User?
    
    func viewDidLoad() {
        view?.showLoadingState(true)
        
        let userId = "usr_123456"
        interactor?.fetchUserData(userId: userId)
    }
    
    func userLoaded(_ user: User) {
        self.user = user
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.displayUsername(user.username)
        }
    }
    
    func accountsLoaded(_ accounts: [BankAccount]) {
        self.accounts = accounts
        
        let accountViewModels = accounts.map { AccountViewModel(from: $0) }
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoadingState(false)
            self?.view?.displayAccounts(accountViewModels)
        }
    }
    
    func didSelectAccount(at index: Int) {
        guard index < accounts.count else { return }
        
        let selectedAccount = accounts[index]
        router?.navigateToAccountDetail(with: selectedAccount)
    }
    
    func transactionsTapped() {
        router?.navigateToTransactions()
    }
    
    func settingsTapped() {
        router?.navigateToSettings()
    }
    
    func handleError(_ error: BankNetworkError) {
        let errorMessage: String
        
        switch error {
        case .invalidURL:
            errorMessage = "Invalid URL"
        case .noData:
            errorMessage = "No data received"
        case .decodingError:
            errorMessage = "Error parsing data"
        case .networkError:
            errorMessage = "Network error"
        case .unauthorized:
            errorMessage = "Unauthorized. Please login again."
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoadingState(false)
            self?.view?.displayErrorMessage(errorMessage)
        }
    }
}
