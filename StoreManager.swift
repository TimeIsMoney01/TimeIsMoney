import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false

    private let productIDs: [String] = [
        "donation_050",
        "donation_1",
        "donation_2",
        "donation_3",
        "donation_4",
        "donation_5"
    ]

    init() {
        Task {
            await loadProducts()
        }
    }

    func loadProducts() async {
        isLoading = true
        do {
            let storeProducts = try await Product.products(for: productIDs)
            self.products = storeProducts.sorted(by: { $0.displayName < $1.displayName })
        } catch {
            print("Failed to load products: \(error)")
        }
        isLoading = false
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(.verified(_)):
                return true
            default:
                return false
            }
        } catch {
            print("Purchase failed: \(error)")
            return false
        }
    }
}
