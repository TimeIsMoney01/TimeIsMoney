import SwiftUI
import StoreKit

struct SessionView: View {
    let appName: String
    let limit: Int

    @State private var timeUsed: Int = 0
    @State private var showPaywall = false
    @State private var sessionActive = true
    @Environment(\.dismiss) var dismiss
    @StateObject private var store = StoreManager()

    var body: some View {
        ZStack {
            ColorTheme.backgroundBlack
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("You're in a session for")
                    .font(Font.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(ColorTheme.accentOrange)
                Text(appName)
                    .font(Font.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(ColorTheme.textWhite)
                    .bold()

                Text("Time used: \(timeUsed) / \(limit) min")
                    .padding(.top)

                ProgressView(value: Double(timeUsed), total: Double(limit))
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .padding()

                Button("End Session") {
                    triggerLightHaptic()
                    sessionActive = false
                    dismiss()
                }
                .primaryButtonStyle()
            }
            .padding()
        }
        .onAppear {
            startTimer()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(appName: appName, onUnlock: {
                timeUsed = max(0, timeUsed - bonusTime())
                sessionActive = true
                showPaywall = false
            }, store: store)
        }
        .task {
            await store.loadProducts()
        }
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            guard sessionActive else {
                timer.invalidate()
                return
            }

            if timeUsed < limit {
                timeUsed += 1
            } else {
                timer.invalidate()
                showPaywall = true
            }
        }
    }

    func bonusTime() -> Int {
        return max(1, limit / 2)
    }
}
