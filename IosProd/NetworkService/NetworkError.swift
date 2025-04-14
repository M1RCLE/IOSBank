enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown(Error)
    
    var description: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        case .decodingError: return "Error decoding the data"
        case .serverError(let code): return "Server error with code: \(code)"
        case .unknown(let error): return "Unknown error: \(error.localizedDescription)"
        }
    }
}
