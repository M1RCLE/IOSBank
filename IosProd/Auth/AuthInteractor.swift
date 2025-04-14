class AuthInteractor: AuthInteractable {
    weak var presenter: AuthPresentable?
    private let networkService: BankNetworkServiceProtocol
    
    init(networkService: BankNetworkServiceProtocol = BankNetworkService()) {
        self.networkService = networkService
    }
    
    private func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        return email.contains("@") && email.contains(".")
    }
    
    private func isValidPassword(_ password: String?) -> Bool {
        guard let password = password else { return false }
        return password.count >= 6
    }
    
    func validateCredentials(username: String?, password: String?) {
        guard isValidEmail(username) else {
            presenter?.handleError(.invalidEmail)
            return
        }
        
        guard isValidPassword(password) else {
            presenter?.handleError(.invalidPassword)
            return
        }
        
        networkService.authenticate(email: username!, password: password!) { [weak self] result in
            switch result {
            case .success(let userDTO):
                let user = userDTO.toModel()
                let cacheService = UserCacheService()
                cacheService.saveUser(user)
                
                self?.presenter?.authSuccess()
            case .failure:
                self?.presenter?.handleError(.invalidCredentials)
            }
        }
    }
}
