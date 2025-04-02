enum PasswordRecoveryError: Error {
    case invalidEmail
    case networkError(String)
    
    var description: String {
        switch self {
        case .invalidEmail: return "Invalid email format"
        case .networkError(let message): return "Network error: \(message)"
        }
    }
}
