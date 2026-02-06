import Foundation

final class NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        url: URL,
        method: String = "GET",
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Network Service", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func requestData(
        url: URL,
        method: String = "GET",
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
      var request = URLRequest(url: url)
        request.httpMethod = method
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Network Service", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}
