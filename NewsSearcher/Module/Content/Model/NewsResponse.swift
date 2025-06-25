import Foundation

enum NewsResponseStatusType: String, Decodable {
    case ok
    case error
}

enum NewsResponseErrorCodeType: String, Decodable {
    case apiKeyInvalid
}

struct NewsResponseModel: Decodable, Hashable {
    let status: NewsResponseStatusType
    let totalResults: Int32
    let news: [NewsModel]
    
    /// Error Props
    let code: NewsResponseErrorCodeType?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case news = "articles"
        case code
        case message
    }
}
