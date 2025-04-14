import Foundation

class UserInteractor: UserInteractable {
    weak var presenter: UserPresentable?
    private let networkService: BankNetworkServiceProtocol
    private let cacheService: UserCacheServiceable
    
    private var userId: String = ""
    
    init(networkService: BankNetworkServiceProtocol = BankNetworkService(),
         cacheService: UserCacheServiceable = UserCacheService()) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func fetchUserData(userId: String) {
        self.userId = userId
        
        if cacheService.isCacheValid(), let cachedUser = cacheService.loadUser() {
            presenter?.userLoaded(cachedUser)
            
            if let cachedAccounts = cacheService.loadAccounts() {
                presenter?.accountsLoaded(cachedAccounts)
            } else {
                fetchUserAccounts(userId: userId)
            }
            return
        }
        
        fetchUserAccounts(userId: userId)
    }
    
    func fetchUserAccounts(userId: String) {
        networkService.fetchUserAccounts(userId: userId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let accountDTOs):
                let accounts = accountDTOs.map { $0.toModel() }
                self.cacheService.saveAccounts(accounts)
                self.presenter?.accountsLoaded(accounts)
                
            case .failure(let error):
                if let cachedAccounts = self.cacheService.loadAccounts() {
                    self.presenter?.accountsLoaded(cachedAccounts)
                } else {
                    self.presenter?.handleError(error)
                }
            }
        }
    }
}
