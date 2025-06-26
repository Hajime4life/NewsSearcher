import Foundation

struct NewsModel: Decodable, Hashable {
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    let source: SourceModel?
}
