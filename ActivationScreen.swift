
import SwiftUI

struct ActivationScreen: View {
    var body: some View {
        ZStack {
            VStack(spacing: 26) {
                Text("Let’s Finish Setup")
                    .font(FontTheme.titleFont)
                    .multilineTextAlignment(.center)

                Text("Just one step left: install the permission from Safari so we can enforce screen time limits.")
                    .font(FontTheme.bodyFont)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 14) {
                    Text("1. Tap the button below")
                    Text("2. Safari will open")
                    Text("3. Tap 'Allow' when prompted")
                    Text("4. Go to Settings > Profile Downloaded to install")
                }
                .font(FontTheme.bodyFont)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)

                Button("Activate") {
                    triggerLightHaptic()
                    if let url = URL(string: "https://time-is-money-fd03d.web.app/profile-download.html") {
                        UIApplication.shared.open(url)
                    }
                }
                .primaryButtonStyle()
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .softBackground()
    }
}
