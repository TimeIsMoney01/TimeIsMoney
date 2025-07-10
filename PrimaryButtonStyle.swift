import SwiftUI

/// A reusable modifier for primary action buttons.
struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(FontTheme.buttonFont)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(ColorTheme.buttonDarkGray)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

extension View {
    /// Applies the `PrimaryButtonStyle` to this view.
    func primaryButtonStyle() -> some View {
        modifier(PrimaryButtonStyle())
    }
}
