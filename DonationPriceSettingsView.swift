import SwiftUI

struct DonationPriceSettingsView: View {
    @AppStorage("donationPrice") var donationPrice: Double = 1.0
    @Environment(\.presentationMode) var presentationMode

    let options: [Double] = [0.5, 1, 2, 3, 4, 5]

    var body: some View {
        VStack(spacing: 30) {
            Text("Set Donation Price")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text("Choose how much you're willing to donate each time you exceed your daily app limit.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack {
                Slider(value: $donationPrice, in: options.first!...options.last!, step: 0.5)
                    .padding(.horizontal)

                Text(String(format: "$%.2f", donationPrice))
                    .font(.title)
                    .padding(.top, 4)

                Text("recommended\nfor beginners")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .scaleEffect(0.8)
                    .offset(y: -8)
            }

            Button("Confirm Donation Amount") {
                HapticManager.tap()
                presentationMode.wrappedValue.dismiss()
                HapticManager.success()
            }
            .primaryButtonStyle()
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
//
//  DonationPriceSettingsView.swift
//  Time is Money
//
//  Created by Alby on 6/17/25.
//

