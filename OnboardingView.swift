import SwiftUI

struct OnboardingView: View {
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    @State private var pageIndex = 0

    var body: some View {
        ZStack {
            ColorTheme.backgroundBlack
                .ignoresSafeArea()

            TabView(selection: $pageIndex) {
            OnboardingPage(
                title: "Welcome to Time is Money",
                subtitle: "Let's take back your time.",
                buttonTitle: "Next") {
                pageIndex += 1
            }
            .tag(0)

            OnboardingPage(
                title: "Limit distracting apps",
                subtitle: "You choose how much daily time you want to spend on certain apps, and we'll help you enforce it. You only get charged if you break your rules.",
                buttonTitle: "Next") {
                pageIndex += 1
            }
            .tag(1)

            OnboardingPage(
                title: "Set free times & charges",
                subtitle: "Select your free-to-use time, the apps you want to use less, and how much you'll get charged if you go past your limit. 75% of profits go to charity.",
                buttonTitle: "Get Started") {
                onboardingCompleted = true
            }
            .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
    }
}

private struct OnboardingPage: View {
    var title: String
    var subtitle: String
    var buttonTitle: String
    var action: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer(minLength: 20)

            VStack(spacing: 12) {
                Text(title)
                    .font(FontTheme.titleFont)
                    .foregroundColor(ColorTheme.textWhite)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                Text(subtitle)
                    .font(FontTheme.subtitleFont)
                    .foregroundColor(ColorTheme.accentOrange)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
            }

            Spacer()

            Button(action: {
                triggerLightHaptic()
                action()
            }) {
                Text(buttonTitle)
            }
            .primaryButtonStyle()
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top)
    }
}
