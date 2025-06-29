import SwiftUI

struct AppCardView: View {
    let appName: String
    let timeUsed: Int
    let limit: Int
    /// Whether the start button should be disabled.
    let isDisabled: Bool
    let onStart: () -> Void

    var percentUsed: Double {
        guard limit > 0 else { return 0 }
        return min(Double(timeUsed) / Double(limit), 1.0)
    }

    var usageColor: Color {
        switch percentUsed {
        case 0..<0.7: return .green
        case 0.7..<1.0: return .yellow
        default: return .red
        }
    }

    /// The color of the start button depending on the disabled state.
    var buttonColor: Color {
        isDisabled ? Color.gray.opacity(0.5) : usageColor.opacity(0.8)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

            HStack(spacing: 16) {
                Image(systemName: "app.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(usageColor)

                VStack(alignment: .leading, spacing: 6) {
                    Text(appName)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    ProgressView(value: percentUsed)
                        .progressViewStyle(LinearProgressViewStyle(tint: usageColor))
                }

                Spacer()

                Button(action: onStart) {
                    Text("Start")
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(buttonColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .disabled(isDisabled)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }
}
