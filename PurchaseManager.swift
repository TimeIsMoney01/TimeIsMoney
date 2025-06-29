import Foundation
import SwiftUI

// Simulated purchase manager for development use (no Apple Developer Account needed)

class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()

    @Published var lastPurchasedProduct: String? = nil
    @Published var purchaseSuccessMessage: String? = nil

    func purchase(productID: String, donationAmount: Double) {
        // Simulated delay to mimic real purchase flow
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.lastPurchasedProduct = productID
            self.purchaseSuccessMessage = "Simulated purchase successful: \(productID) for $\(String(format: "%.2f", donationAmount))"
            print(self.purchaseSuccessMessage ?? "")
        }
    }

    func reset() {
        lastPurchasedProduct = nil
        purchaseSuccessMessage = nil
    }
}