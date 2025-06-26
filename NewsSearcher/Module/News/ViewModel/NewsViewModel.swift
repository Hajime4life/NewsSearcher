import SwiftUI

@Observable
final class NewsViewModel {
    // MARK: - Public Props
    var searchText: String = ""
    var searchLanguage: Constants.language = .ru {
        didSet {
            localStorage.set(searchLanguage.rawValue, forKey: storageKeys.selectedLanguage.rawValue)
        }
    }


    // MARK: - Private Props
    private(set) var news: [NewsModel] = []
    private let networkManager: NetworkManager
    private let localStorage: LocalStorage
    private let alertViewModel: AlertViewModel

    // MARK: - Initialization
    init(
        networkManager: NetworkManager = NetworkManager(),
        localStorage: LocalStorage = LocalStorage(),
        alertViewModel: AlertViewModel
    ) {
        self.networkManager = networkManager
        self.localStorage = localStorage
        self.alertViewModel = alertViewModel
        if let savedLanguage = localStorage.get(forKey: storageKeys.selectedLanguage.rawValue),
           let language = Constants.language(rawValue: savedLanguage) {
            self.searchLanguage = language
        } else {
            self.searchLanguage = .ru
        }
    }

    // MARK: - Public Methods
    func fetchNews() {
        networkManager.fetchNews(query: searchText, language: searchLanguage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let news):
                if news.isEmpty {
                    self.alertViewModel.showAlert(message: NSLocalizedString("Новостей не найдено", comment: "Empty news message")) // TODO: Локализовать
                } else {
                    self.news = news
                }
            case .failure(let error):
                self.alertViewModel.showAlert(message: error.localizedDescription) // TODO: Локализовать
            }
        }
    }
    
    func searchByButton(type: searchButtonType) {
        self.searchText = type.rawValue
        self.fetchNews()
    }

    func switchLanguage(_ newLanguage: Constants.language) {
        searchLanguage = newLanguage
    }
}
