
import SwiftUI

struct OnboardingView: View {
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    @State private var pageIndex = 0

    var body: some View {
        TabView(selection: $pageIndex) {
            VStack(spacing: 30) {
                Text("Welcome to Time is Money.\nLet's take back your time.")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                Button(action: {
                    HapticManager.tap()
                    pageIndex += 1
                }) {
                    Text("Continue")
                        .font(.system(size: 22, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.top, -40)
            }
            .tag(0)

            VStack(spacing: 30) {
                Text("You choose how much daily time you want to spend on certain apps, and we’ll help you enforce it. You only get charged if you break your rules.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()

                Button(action: {
                    HapticManager.tap()
                    pageIndex += 1
                }) {
                    Text("Continue")
                        .font(.system(size: 22, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.top, -40)
            }
            .tag(1)

            VStack(spacing: 20) {
                Text("Select your free-to-use time (ex: work/school hours), the apps you want to use less, and how much you’ll get charged if you choose to go past your limit (50¢ to $5).")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()

                Text("You always get to choose if you want to go past your limit, and 75% of profits go to charity.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button(action: {
                    HapticManager.tap()
                    onboardingCompleted = true
                    HapticManager.success()
                }) {
                    Text("Get Started")
                        .font(.system(size: 22, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.top, -20)
            }
            .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}
