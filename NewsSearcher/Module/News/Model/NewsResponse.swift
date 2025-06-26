import Foundation

enum NewsResponseStatusType: String, Decodable {
    case ok
    case error
}

enum NewsResponseErrorCodeType: String, Decodable {
    case apiKeyInvalid
    case rateLimited
    case parameterInvalid
    case unknown
    
    var localizedDescription: String {
        switch self { // TODO: Локализовать
        case .apiKeyInvalid: return NSLocalizedString("Неверный токен", comment: "API key invalid")
        case .rateLimited: return NSLocalizedString("Лимит просмотра новостей исчерпан", comment: "Rate limited")
        case .parameterInvalid: return NSLocalizedString("Некорректный параметр", comment: "Parameter invalid")
        case .unknown: return NSLocalizedString("Неизвестная ошибка", comment: "Unknown error")
        }
    }
}

struct NewsResponseModel: Decodable, Hashable {
    let status: NewsResponseStatusType
    let totalResults: Int32?
    let news: [NewsModel]?
    let code: NewsResponseErrorCodeType? /// Для ошибок
    let message: String? /// Для ошибок
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case news = "articles"
        case code
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(NewsResponseStatusType.self, forKey: .status)
        totalResults = try container.decodeIfPresent(Int32.self, forKey: .totalResults)
        news = try container.decodeIfPresent([NewsModel].self, forKey: .news) ?? []
        code = try container.decodeIfPresent(NewsResponseErrorCodeType.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}
