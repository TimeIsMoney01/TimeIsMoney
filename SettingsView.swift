import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    var onResetLimits: () -> Void
    var onResetSessions: () -> Void
    var onRecallOnboarding: () -> Void

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Reset")) {
                    Button("Reset All App Limits") {
                        onResetLimits()
                    }
                    Button("Reset All App Sessions") {
                        onResetSessions()
                    }
                }

                Section(header: Text("Onboarding")) {
                    Button("See Onboarding Again") {
                        onRecallOnboarding()
                    }
                }

                Section(header: Text("About")) {
                    Text("Time is Money v1.0")
                    Text("75% of profits go to charity.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isPresented = false
                    }
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

