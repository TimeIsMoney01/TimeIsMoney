import SwiftUI

struct DonationSliderView: View {
    @Binding var amount: Double
    let presetValues: [Double] = [0.5, 1, 2, 3, 4, 5]

    var body: some View {
        VStack(spacing: 10) {
            Slider(value: $amount, in: 0.5...5, step: 0.5)
            
            Text(String(format: "$%.2f", amount))
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
}
