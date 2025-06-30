
import SwiftUI

struct ActivationScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 120/255, green: 90/255, blue: 160/255),
                    Color(red: 160/255, green: 140/255, blue: 200/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Color.white.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 26) {
                Text("Let’s Finish Setup")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)

                Text("Just one step left: install the permission from Safari so we can enforce screen time limits.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 14) {
                    Text("1. Tap the button below")
                    Text("2. Safari will open")
                    Text("3. Tap 'Allow' when prompted")
                    Text("4. Go to Settings > Profile Downloaded to install")
                }
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)

                Button("Activate") {
                    HapticManager.tap()
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
    }
}
