import Foundation

extension String {
    func toHumanReadableDate() -> String? {
        guard !self.isEmpty else { return nil }
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            //dateFormatter.locale = Locale(identifier: "ru_RU") // TODO: Может вернуть
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
