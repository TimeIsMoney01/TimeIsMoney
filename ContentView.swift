
import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    @StateObject private var store = StoreManager()

    var body: some View {
        ZStack {
            ColorTheme.backgroundBlack
                .ignoresSafeArea()
            if onboardingCompleted {
                MainAppView(store: store)
                    .transition(.move(edge: .trailing))
            } else {
                OnboardingView()
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut, value: onboardingCompleted)
    }
}
