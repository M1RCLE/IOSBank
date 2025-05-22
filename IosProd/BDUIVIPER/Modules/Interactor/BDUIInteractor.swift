import Foundation

final class BDUIInteractor: BDUIInteractorInputProtocol {
    weak var presenter: BDUIInteractorOutputProtocol?
    
    // MARK: - BDUIInteractorInputProtocol
    
    func fetchUI(from endpoint: String, storageKey: String?, username: String?, password: String?) {
        var finalEndpoint = endpoint
        if let key = storageKey {
            if finalEndpoint.hasSuffix("/") {
                finalEndpoint += key
            } else {
                finalEndpoint += "/\(key)"
            }
        }
        
        guard let url = URL(string: finalEndpoint) else {
            presenter?.didFailFetchingUI(with: NSError(
                domain: "BDUIErrorDomain",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]
            ))
            return
        }
        
        var request = URLRequest(url: url)
        
        if let username = username, let password = password {
            let loginString = "\(username):\(password)"
            if let loginData = loginString.data(using: .utf8) {
                let base64LoginString = loginData.base64EncodedString()
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.presenter?.didFailFetchingUI(with: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.presenter?.didFailFetchingUI(with: NSError(
                        domain: "BDUIErrorDomain",
                        code: -2,
                        userInfo: [NSLocalizedDescriptionKey: "Invalid response"]
                    ))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    var errorMessage = "Server error: \(httpResponse.statusCode)"
                    
                    if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                        errorMessage = "Authentication failed. Please check your credentials."
                    } else if httpResponse.statusCode == 404 {
                        errorMessage = "Resource not found. Check storage key or endpoint."
                    }
                    
                    self.presenter?.didFailFetchingUI(with: NSError(
                        domain: "BDUIErrorDomain",
                        code: httpResponse.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: errorMessage]
                    ))
                    return
                }
                
                guard let data = data else {
                    self.presenter?.didFailFetchingUI(with: NSError(
                        domain: "BDUIErrorDomain",
                        code: -3,
                        userInfo: [NSLocalizedDescriptionKey: "No data received"]
                    ))
                    return
                }
                
                self.parseUI(from: data)
            }
        }
        
        task.resume()
    }
    
    func parseUI(from jsonData: Data) {
        do {
            let decoder = JSONDecoder()
            let rootElement = try decoder.decode(BDUIElement.self, from: jsonData)
            presenter?.didFetchUI(element: rootElement)
        } catch {
            print("Error decoding JSON: \(error)")
            presenter?.didFailFetchingUI(with: error)
        }
    }
    
    func parseUI(from jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            presenter?.didFailFetchingUI(with: NSError(
                domain: "BDUIErrorDomain",
                code: -4,
                userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string"]
            ))
            return
        }
        parseUI(from: data)
    }
} 