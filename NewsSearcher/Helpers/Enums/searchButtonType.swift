enum searchButtonType: String, CaseIterable {
    case sport = "Спорт"
    case politics = "Политика"
    case technology = "Технологии"
    case business = "Бизнес"
    case entertainment = "Развлечения"
    
    var buttonName: String {
        rawValue
    }
}
