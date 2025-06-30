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
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.5), Color.blue.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("You're in a session for")
                    .font(.title2)
                Text(appName)
                    .font(.largeTitle.bold())

                Text("Time used: \(timeUsed) / \(limit) min")
                    .padding(.top)

                ProgressView(value: Double(timeUsed), total: Double(limit))
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .padding()

                Button("End Session") {
                    HapticManager.tap()
                    sessionActive = false
                    dismiss()
                }
                .padding()
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .clipShape(Capsule())
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
