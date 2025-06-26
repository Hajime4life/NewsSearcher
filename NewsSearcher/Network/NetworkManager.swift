import Foundation

// MARK: - Enums
enum NetworkErrorType: String, Error {
    case invalidURL = "Невалидный URL"
    case decodingFailed = "Ошибка декодирования"
    case noData = "Нет данных"
    case urlSessionFailed = "Ошибка сессии URLSession"
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
    func fetchNews(
        query: String,
        language: Constants.language = .ru,
        sortType: Constants.sortType = .new,
        completion: @escaping (Result<[NewsModel], Error>) -> Void
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkProtocolType.https.rawValue
        urlComponents.host = Constants.newsHost
        urlComponents.path = "/v2/everything"
                
        var queryItems: [URLQueryItem] = []
        let queryValue = query.isEmpty ? "news" : query
        queryItems.append(URLQueryItem(name: "q", value: queryValue))
        queryItems.append(URLQueryItem(name: "pageSize", value: Constants.queryPageSize.toString()))
        queryItems.append(URLQueryItem(name: "language", value: language.rawValue))
        queryItems.append(URLQueryItem(name: "sortBy", value: sortType.rawValue))
        queryItems.append(URLQueryItem(name: "apiKey", value: Secrets.newsApiKey))
        urlComponents.queryItems = queryItems
                
        guard let url = urlComponents.url else {
            print("❌ \(NetworkErrorType.invalidURL.rawValue)")
            completion(.failure(NetworkErrorType.invalidURL))
            return
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = NetworkMethods.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ Ошибка сети: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("❌ \(NetworkErrorType.noData.rawValue)")
                completion(.failure(NetworkErrorType.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("⚠️ Ответ: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NewsResponseModel.self, from: data)
                
                if response.status == .ok {
                    completion(.success(response.news ?? []))
                } else {
                    let errorMessage = response.code?.localizedDescription ?? (response.message ?? NSLocalizedString("Unknown API error", comment: "Default API error message"))
                    let apiError = NSError(domain: "NewsAPI", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: errorMessage
                    ])
                    print("❌ Ошибка: \(errorMessage)")
                    completion(.failure(apiError))
                }
            } catch {
                print("❌ Ошибка декодирования: \(error)")

                if let jsonString = String(data: data, encoding: .utf8),
                   let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let errorResponse = try JSONDecoder().decode(NewsResponseModel.self, from: jsonData)
                        if errorResponse.status != .ok, let errorMessage = errorResponse.message {
                            let apiError = NSError(domain: "NewsAPI", code: -1, userInfo: [
                                NSLocalizedDescriptionKey: errorMessage
                            ])
                            completion(.failure(apiError))
                        } else {
                            completion(.failure(NetworkErrorType.decodingFailed))
                        }
                    } catch {
                        completion(.failure(NetworkErrorType.decodingFailed))
                    }
                } else {
                    completion(.failure(NetworkErrorType.decodingFailed))
                }
            }
        }.resume()
    }
}
