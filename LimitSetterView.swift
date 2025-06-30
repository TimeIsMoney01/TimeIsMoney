import SwiftUI

struct LimitSetterView: View {
    @AppStorage("appLimits") private var appLimitsData: Data?
    @State private var appLimits: [String: Int] = [:]
    @State private var selectedLimit = 30

    let apps = ["TikTok", "Instagram", "YouTube", "Snapchat", "Reddit"]

    var body: some View {
        NavigationView {
            List {
                ForEach(apps, id: \.self) { app in
                    VStack(alignment: .leading) {
                        Text(app)
                            .font(FontTheme.subtitleFont)
                        Slider(value: Binding(
                            get: { Double(appLimits[app] ?? 30) },
                            set: { appLimits[app] = Int($0) }
                        ), in: 0...180, step: 5)
                        Text("Limit: \(appLimits[app] ?? 30) minutes")
                            .font(FontTheme.bodyFont)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Set App Limits")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        triggerLightHaptic()
                        saveAppLimits()
                        HapticManager.success()
                    }
                }
            }
        }
        .softBackground()
        .onAppear {
            loadAppLimits()
        }
    }

    func saveAppLimits() {
        if let data = try? JSONEncoder().encode(appLimits) {
            appLimitsData = data
        }
    }

    func loadAppLimits() {
        if let data = appLimitsData,
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            appLimits = decoded
        }
    }
}
