import Foundation

enum storageKeys: String {
    case selectedLanguage = "selectedLanguage"
    case favoriteArticles = "favoriteArticles"
}

final class LocalStorage {
    
    // MARK: - Private Props
    private let localStorage: UserDefaults

    // MARK: - Initialization
    init(localStorage: UserDefaults = .standard) {
        self.localStorage = localStorage
    }

    // MARK: - Public Methods
    func set(_ value: String, forKey key: String) {
        localStorage.set(value, forKey: key)
    }

    func get(forKey key: String) -> String? {
        return localStorage.string(forKey: key)
    }

    func remove(forKey key: String) {
        localStorage.removeObject(forKey: key)
    }
    
}
