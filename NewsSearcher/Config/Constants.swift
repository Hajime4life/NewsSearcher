enum Constants {
    
    static let newsHost: String = "newsapi.org"
    
    enum language: String {
        case en = "en"
        case ru = "ru"
    }
    
    static let queryPageSize: Int32 = 20
    
    enum sortType: String {
        case new = "PublishedAt"
    }
}
