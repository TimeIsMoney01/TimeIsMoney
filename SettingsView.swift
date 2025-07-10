import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    var onResetLimits: () -> Void
    var onResetSessions: () -> Void
    var onRecallOnboarding: () -> Void

    var body: some View {
        ZStack {
            ColorTheme.backgroundBlack
                .ignoresSafeArea()

            NavigationView {
            List {
                Section(header: Text("Reset")) {
                    Button("Reset All App Limits") {
                        triggerLightHaptic()
                        onResetLimits()
                        HapticManager.success()
                    }
                    .primaryButtonStyle()
                    Button("Reset All App Sessions") {
                        triggerLightHaptic()
                        onResetSessions()
                        HapticManager.success()
                    }
                    .primaryButtonStyle()
                }

                Section(header: Text("Onboarding")) {
                    Button("See Onboarding Again") {
                        triggerLightHaptic()
                        onRecallOnboarding()
                    }
                    .primaryButtonStyle()
                }

                Section(header: Text("About")) {
                    Text("Time is Money v1.0")
                    Text("75% of profits go to charity.")
                        .font(Font.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        triggerLightHaptic()
                        isPresented = false
                    }
                    .primaryButtonStyle()
                }
            }
        }
    }
}
//
//  SettingsView.swift
//  Time is Money
//
//  Created by Alby on 6/25/25.
//

