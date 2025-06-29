import SwiftUI

/// The main entry point of the app. Requests notification permissions on launch.
@main
struct Time_is_MoneyApp: App {
    init() {
        NotificationManager.shared.requestAuthorization()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
