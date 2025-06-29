
import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    @StateObject private var store = StoreManager()

    var body: some View {
        if !onboardingCompleted {
            OnboardingView()
        } else {
            MainAppView(store: store)
        }
    }
}
