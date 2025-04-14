import Foundation

enum BankNetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case unauthorized
}

protocol BankNetworkServiceProtocol {
    func fetchUserAccounts(userId: String, completion: @escaping (Result<[BankAccountDTO], BankNetworkError>) -> Void)
    func fetchUserTransactions(userId: String, completion: @escaping (Result<[TransactionDTO], BankNetworkError>) -> Void)
    func authenticate(email: String, password: String, completion: @escaping (Result<UserDTO, BankNetworkError>) -> Void)
}

class BankNetworkService: BankNetworkServiceProtocol {
    private let baseURL = "https://api.bankapp.example.com"
    private var authToken: String?
    
    func authenticate(email: String, password: String, completion: @escaping (Result<UserDTO, BankNetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            completion(.failure(.invalidURL))
            return
        }
        
        // TODO: реальном приложении здесь будет настоящий запрос авторизации
        
        // Имитация задержки сети
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            if email == "test@example.com" && password == "123456" {
                // Имитация успешного ответа
                let currentDate = Date()
                let user = UserDTO(
                    id: "usr_123456",
                    username: "testuser",
                    email: email,
                    accounts: [
                        BankAccountDTO(
                            id: "acc_12345",
                            accountType: .debit,
                            creationDate: currentDate.addingTimeInterval(-60*60*24*30), // 30 дней назад
                            balance: 1250.75
                        ),
                        BankAccountDTO(
                            id: "acc_67890",
                            accountType: .credit,
                            creationDate: currentDate.addingTimeInterval(-60*60*24*15), // 15 дней назад
                            balance: 500.0
                        )
                    ]
                )
                
                self.authToken = "fake_auth_token_123"
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.unauthorized))
                }
            }
        }
    }
    
    func fetchUserAccounts(userId: String, completion: @escaping (Result<[BankAccountDTO], BankNetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(userId)/accounts") else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let _ = authToken else {
            completion(.failure(.unauthorized))
            return
        }
        
        // TODO: реальном приложении здесь будет настоящий запрос к API
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let currentDate = Date()
            let accounts = [
                BankAccountDTO(
                    id: "acc_12345",
                    accountType: .debit,
                    creationDate: currentDate.addingTimeInterval(-60*60*24*30), // 30 дней назад
                    balance: 1250.75
                ),
                BankAccountDTO(
                    id: "acc_67890",
                    accountType: .credit,
                    creationDate: currentDate.addingTimeInterval(-60*60*24*15), // 15 дней назад
                    balance: 500.0
                ),
                BankAccountDTO(
                    id: "acc_24680",
                    accountType: .debit,
                    creationDate: currentDate.addingTimeInterval(-60*60*24*5), // 5 дней назад
                    balance: 3750.25
                )
            ]
            
            completion(.success(accounts))
        }
    }
    
    func fetchUserTransactions(userId: String, completion: @escaping (Result<[TransactionDTO], BankNetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(userId)/transactions") else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let _ = authToken else {
            completion(.failure(.unauthorized))
            return
        }
        
        // TODO: реальном приложении здесь будет настоящий запрос к API
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
            let currentDate = Date()
            let transactions = [
                TransactionDTO(
                    id: "tx_12345",
                    fromAccount: "acc_12345",
                    toAccount: "ext_account_1",
                    amount: 100.0,
                    date: currentDate.addingTimeInterval(-60*60*24*2) // 2 дня назад
                ),
                TransactionDTO(
                    id: "tx_67890",
                    fromAccount: "ext_account_2",
                    toAccount: "acc_12345",
                    amount: 500.0,
                    date: currentDate.addingTimeInterval(-60*60*24*5) // 5 дней назад
                ),
                TransactionDTO(
                    id: "tx_24680",
                    fromAccount: "acc_67890",
                    toAccount: "ext_account_3",
                    amount: 75.50,
                    date: currentDate.addingTimeInterval(-60*60*24*7) // 7 дней назад
                )
            ]
            
            completion(.success(transactions))
        }
    }
}
