import SwiftUI

/// Provides a neutral background gradient that adapts to light and dark mode.
struct SoftBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(UIColor.systemBackground),
                    Color(UIColor.secondarySystemBackground)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            content
        }
    }
}

extension View {
    /// Applies a soft neutral gradient background behind this view.
    func softBackground() -> some View {
        modifier(SoftBackgroundModifier())
    }
}
