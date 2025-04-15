import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func authenticate(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if username == "test@example.com" && password == "123456" {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        }
    }
    
    func request<T: Decodable>(endpoint: String, method: String = "GET", completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}
