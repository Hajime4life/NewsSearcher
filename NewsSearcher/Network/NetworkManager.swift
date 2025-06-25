import Foundation

// MARK: - Enums
enum NetworkErrorType: Error {
    case invalidURL
    case decodingFailed
    case noData
    case urlSessionFailed
}

enum NetworkProtocolType: String {
    case http = "http"
    case https = "https"
}

enum NetworkMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
}

// MARK: - Class NetworkManager
final class NetworkManager {
    
    /// Получить список новостей
    final func fetchNews(
        query: String,
        language: Constants.language = .ru,
        completion: @escaping (Result<[NewsModel], Error>) -> Void
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkProtocolType.https.rawValue
        urlComponents.host = Constants.newsHost
        urlComponents.path = "/v2/everything"
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: query))
        //queryItems.append(URLQueryItem(name: "pageSize", value: Constants.queryPageSize.toString()))
        queryItems.append(URLQueryItem(name: "language", value: language.rawValue))
        queryItems.append(URLQueryItem(name: "apiKey", value: Secrets.newsApiKey))
        urlComponents.queryItems = queryItems
                
        guard let url = urlComponents.url else {
            completion(.failure(NetworkErrorType.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = NetworkMethods.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkErrorType.noData))
                return
            }
            
            print("\(res)")
            
            if let response = try? JSONDecoder().decode(NewsResponseModel.self, from: data) {
                completion(.success(response.news))
            } else {
                // TODO: Тут наверно нужно проверить не некорректный ли токен
                completion(.failure(NetworkErrorType.decodingFailed))
            }
        }.resume()
    }
}
