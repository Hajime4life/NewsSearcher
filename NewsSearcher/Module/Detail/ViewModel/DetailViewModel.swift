import SwiftUI
    
@Observable
final class DetailViewModel {
    var news: NewsModel
    
    init(news: NewsModel) {
        self.news = news
    }
}
