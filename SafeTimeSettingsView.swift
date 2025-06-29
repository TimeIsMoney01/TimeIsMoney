import SwiftUI

struct SafeTimeSettingsView: View {
    @ObservedObject var safeTimeManager: SafeTimeManager
    @State private var selectedStart = Date()
    @State private var selectedEnd = Date().addingTimeInterval(3600)

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select your Safe Time Window")) {
                    DatePicker("Start Time", selection: $selectedStart, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $selectedEnd, displayedComponents: .hourAndMinute)
                }

                Section {
                    Button("Save Safe Time") {
                        safeTimeManager.setSafeTime(start: selectedStart, end: selectedEnd)
                    }
                    .disabled(!safeTimeManager.canUpdateSafeTime)
                }

                if !safeTimeManager.canUpdateSafeTime {
                    Text("You can update your safe time again in \(safeTimeManager.remainingDays) days.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle("Safe Time Settings")
        }
        .onAppear {
            selectedStart = safeTimeManager.safeStart
            selectedEnd = safeTimeManager.safeEnd
        }
    }
}
