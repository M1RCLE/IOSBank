import Foundation

class UserCacheService: UserCacheServiceable {
    private let accountsCacheKey = "cachedAccounts"
    private let userCacheKey = "cachedUser"
    private let cacheValidityKey = "accountsCacheTimestamp"
    private let cacheValidityInterval: TimeInterval = 60 * 15 // 15 минут
    
    func saveAccounts(_ accounts: [BankAccount]) {
        do {
            let accountDTOs = accounts.map { BankAccountDTO.fromModel($0) }
            let data = try JSONEncoder().encode(accountDTOs)
            UserDefaults.standard.set(data, forKey: accountsCacheKey)
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: cacheValidityKey)
        } catch {
            print("Error caching accounts: \(error)")
        }
    }
    
    func loadAccounts() -> [BankAccount]? {
        guard let data = UserDefaults.standard.data(forKey: accountsCacheKey) else {
            return nil
        }
        
        do {
            let accountDTOs = try JSONDecoder().decode([BankAccountDTO].self, from: data)
            return accountDTOs.map { $0.toModel() }
        } catch {
            print("Error loading cached accounts: \(error)")
            return nil
        }
    }
    
    func saveUser(_ user: User) {
        do {
            let userDTO = UserDTO.fromModel(user)
            let data = try JSONEncoder().encode(userDTO)
            UserDefaults.standard.set(data, forKey: userCacheKey)
        } catch {
            print("Error caching user: \(error)")
        }
    }
    
    func loadUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: userCacheKey) else {
            return nil
        }
        
        do {
            let userDTO = try JSONDecoder().decode(UserDTO.self, from: data)
            return userDTO.toModel()
        } catch {
            print("Error loading cached user: \(error)")
            return nil
        }
    }
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: accountsCacheKey)
        UserDefaults.standard.removeObject(forKey: userCacheKey)
        UserDefaults.standard.removeObject(forKey: cacheValidityKey)
    }
    
    func isCacheValid() -> Bool {
        guard let timestamp = UserDefaults.standard.double(forKey: cacheValidityKey) as Double? else {
            return false
        }
        
        let currentTime = Date().timeIntervalSince1970
        return currentTime - timestamp < cacheValidityInterval
    }
}
