import SwiftUI

@Observable
final class AlertViewModel {
    var isPresented: Bool = false
    var message: String = ""

    func showAlert(message: String) {
        self.message = message
        self.isPresented = true
    }

    func dismissAlert() {
        self.isPresented = false
        self.message = ""
    }
}
