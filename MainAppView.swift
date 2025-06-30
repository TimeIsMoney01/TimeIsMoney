import SwiftUI

struct MainAppView: View {
    @AppStorage("appLimits") var appLimitsData: Data?
    @AppStorage("appSessions") var appSessionsData: Data?
    @AppStorage("donationAmount") var donationAmount: Double = 1.0

    @State private var appLimits: [String: Int] = [:]
    @State private var appSessions: [String: Int] = [:]
    @State private var selectedApp: String?
    @State private var showPaywall = false
    @State private var showSafeTimeSettings = false
    @StateObject private var safeTimeManager = SafeTimeManager()

    let store: StoreManager
    let apps = ["TikTok", "Instagram", "YouTube", "Snapchat", "Reddit"]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.gray.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

        ScrollView {
            VStack(spacing: 30) {
                Text("Time Is Money")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                    .padding(.top, 20)

                Button("Safe Time Settings") {
                    HapticManager.tap()
                    showSafeTimeSettings = true
                }
                .primaryButtonStyle()

                ForEach(apps, id: \.self) { app in
                    let limitReached = (appSessions[app] ?? 0) >= (appLimits[app] ?? 0)

                    AppCardView(
                        appName: app,
                        timeUsed: appSessions[app] ?? 0,
                        limit: appLimits[app] ?? 0,
                        isDisabled: false
                    ) {
                        if !isInSafeTime || limitReached {
                            selectedApp = app
                            showPaywall = true
                        } else {
                            let newUsage = (appSessions[app] ?? 0) + 1
                            appSessions[app] = newUsage
                            saveAppSessions()

                            let limit = appLimits[app] ?? 0
                            if limit > 0 {
                                if newUsage == limit / 2 {
                                    NotificationManager.shared.notifyHalfLimitReached(for: app)
                                }
                                if newUsage == limit {
                                    NotificationManager.shared.notifyLimitReached(for: app)
                                }
                            }
                        }
                    }
                }
                }
                .padding()
            }
        }
        .onAppear {
            loadAppLimits()
            loadAppSessions()
        }
        .sheet(isPresented: $showPaywall) {
            if let app = selectedApp {
                PaywallView(appName: app, onUnlock: {
                    appSessions[app, default: 0] += bonusTime(for: app)
                    saveAppSessions()
                    HapticManager.success()
                    showPaywall = false
                }, store: store)
            }
        }
        .sheet(isPresented: $showSafeTimeSettings) {
            SafeTimeSettingsView(safeTimeManager: safeTimeManager)
        }
    }

    func loadAppLimits() {
        if let data = appLimitsData,
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            appLimits = decoded
        }
    }

    func loadAppSessions() {
        if let data = appSessionsData,
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            appSessions = decoded
        }
    }

    func saveAppSessions() {
        if let encoded = try? JSONEncoder().encode(appSessions) {
            appSessionsData = encoded
        }
    }

    func bonusTime(for app: String) -> Int {
        let limit = appLimits[app, default: 0]
        return max(1, limit / 2)
    }

    /// Returns `true` when the current time falls within the user's configured
    /// Safe Time window.
    var isInSafeTime: Bool {
        safeTimeManager.updateCurrentTime()
        return safeTimeManager.isInSafeTime
    }
}
