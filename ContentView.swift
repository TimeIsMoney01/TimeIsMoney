
import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = true
    @StateObject private var store = StoreManager()

    var body: some View {
        if showOnboarding {
            OnboardingView {
                showOnboarding = false
            }
        } else {
            MainAppView(store: store)
        }
    }
}
