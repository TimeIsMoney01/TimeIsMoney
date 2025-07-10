import SwiftUI

struct InstallProfileInstructionsView: View {
    @AppStorage("profileInstalled") var profileInstalled: Bool = false

    var body: some View {
        ZStack {
            ColorTheme.backgroundBlack
                .ignoresSafeArea()

            VStack(spacing: 30) {
            Spacer(minLength: 20)

            VStack(spacing: 8) {
                Text("Let’s Finish Setup")
                    .font(FontTheme.titleFont)
                    .foregroundColor(ColorTheme.textWhite)
                    .bold()
                    .multilineTextAlignment(.center)

                Text("Just one step left: install the permission in Safari so we can enforce your screen time limits.")
                    .font(FontTheme.bodyFont)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            VStack(alignment: .leading, spacing: 20) {
                Text("1. Tap the button below")
                Text("2. Safari will open the install page")
                Text("3. Tap “Allow” and follow the prompts")
                Text("4. Return to this app and tap Continue")
            }
            .font(FontTheme.subtitleFont) // 🔠 Larger font
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)

            Button(action: {
                triggerLightHaptic()
                if let url = URL(string: "https://time-is-money-fd03d.web.app/profile-download.html") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Open Install Page")
            }
            .primaryButtonStyle()
            .padding(.horizontal)

            Button(action: {
                triggerLightHaptic()
                profileInstalled = true
                HapticManager.success()
            }) {
                Text("Continue")
            }
            .primaryButtonStyle()
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
    }
}
