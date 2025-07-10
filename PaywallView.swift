import SwiftUI
import StoreKit

struct PaywallView: View {
    let appName: String
    let onUnlock: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: StoreManager

    var body: some View {
        ZStack {
            ColorTheme.backgroundBlack
                .ignoresSafeArea()

            NavigationView {
            VStack(spacing: 30) {
                Text("Time’s Up for \(appName)")
                    .font(Font.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(ColorTheme.textWhite)
                    .bold()
                    .multilineTextAlignment(.center)

                Text("You’ve reached your limit. To keep going, donate an amount below to unlock more time.")
                    .font(Font.system(size: 24, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if store.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    productList
                }

                Button("Cancel") {
                    triggerLightHaptic()
                    dismiss()
                }
                .primaryButtonStyle()
                .foregroundColor(.red)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await store.loadProducts()
            }
        }
    }

    var productList: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(store.products, id: \.id) { product in
                    DonationProductButton(product: product) {
                        triggerLightHaptic()
                        Task {
                            let success = await store.purchase(product)
                            if success {
                                HapticManager.success()
                                onUnlock()
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct DonationProductButton: View {
    let product: Product
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading) {
                    Text(product.displayName)
                        .font(Font.system(size: 24, weight: .bold, design: .default))
                    Text(product.description)
                        .font(Font.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(product.displayPrice)
                    .font(Font.system(size: 24, weight: .bold, design: .default))
            }
            .padding()
        }
        .primaryButtonStyle()
    }
}
