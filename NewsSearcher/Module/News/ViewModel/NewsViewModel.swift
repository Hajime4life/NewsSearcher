import SwiftUI
    
@Observable
final class  NewsViewModel {
    
    // MARK: - Public Props
    var searchText: String = ""

    // MARK: - Private Props
    private let networkManager: NetworkManager = NetworkManager()
    private(set) var news: [NewsModel] = []
    
    // MARK: - Public Methods
    final func fetchNews() {
        networkManager.fetchNews(query: searchText) { result in
            switch result {
                case .success(let news):
                    self.news = news
                case .failure(let error):
                    print(error)
                    // TODO: Добавить алёрт
            }
        }
    }
    
    
}
