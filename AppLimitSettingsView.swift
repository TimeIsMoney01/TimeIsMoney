import SwiftUI

struct AppLimitSettingsView: View {
    @AppStorage("appLimits") var appLimitsData: Data = Data()
    @State private var appLimits: [String: Int] = [
        "TikTok": 0,
        "Instagram": 0,
        "YouTube": 0,
        "Snapchat": 0,
        "Reddit": 0
    ]

    @State private var showDonationPriceScreen = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Set Daily Limits")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            List {
                ForEach(appLimits.keys.sorted(), id: \.self) { app in
                    VStack(alignment: .leading) {
                        Text(app)
                            .font(.headline)

                        Slider(value: Binding(
                            get: { Double(appLimits[app] ?? 0) },
                            set: { appLimits[app] = Int($0) }
                        ), in: 0...120, step: 5)

                        Text("\(appLimits[app] ?? 0) minutes")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
            }

            Button("Save Limits") {
                HapticManager.tap()
                saveLimits()
                HapticManager.success()
                showDonationPriceScreen = true
            }
            .primaryButtonStyle()
            .padding(.horizontal)

            Spacer()
        }
        .onAppear {
            loadLimits()
        }
        .sheet(isPresented: $showDonationPriceScreen) {
            DonationPriceSettingsView()
        }
    }

    func saveLimits() {
        if let encoded = try? JSONEncoder().encode(appLimits) {
            appLimitsData = encoded
        }
    }

    func loadLimits() {
        if let decoded = try? JSONDecoder().decode([String: Int].self, from: appLimitsData) {
            appLimits = decoded
        }
    }
}
