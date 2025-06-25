import Foundation

enum NetworkErrorType: Error {
    case invalidURL
    case decodingFailed
    case noData
    case urlSessionFailed
}

final class NetworkManager {
    final func fetchNews(query: String, completion: @escaping (Result<[NewsModel], Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/everything"
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: query))
        queryItems.append(URLQueryItem(name: "apiKey", value: Secrets.newsApiKey))
    }
}
