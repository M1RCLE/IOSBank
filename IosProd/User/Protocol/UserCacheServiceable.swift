protocol UserCacheServiceable {
    func saveAccounts(_ accounts: [BankAccount])
    func loadAccounts() -> [BankAccount]?
    func saveUser(_ user: User)
    func loadUser() -> User?
    func clearCache()
    func isCacheValid() -> Bool
}
