import SwiftUI

struct SafeTimeSettingsView: View {
    @ObservedObject var safeTimeManager: SafeTimeManager
    @State private var selectedStart = Date()
    @State private var selectedEnd = Date().addingTimeInterval(3600)
    @State private var selectedDays: Set<Int> = []

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select your Safe Time Window")) {
                    DatePicker("Start Time", selection: $selectedStart, displayedComponents: .hourAndMinute)
                        .disabled(!safeTimeManager.canUpdateSafeTime)
                    DatePicker("End Time", selection: $selectedEnd, displayedComponents: .hourAndMinute)
                        .disabled(!safeTimeManager.canUpdateSafeTime)
                }

                Section(header: Text("Active Days")) {
                    ForEach(1...7, id: \.self) { day in
                        let label = Calendar.current.weekdaySymbols[day - 1]
                        Toggle(label, isOn: Binding(
                            get: { selectedDays.contains(day) },
                            set: { isOn in
                                if isOn { selectedDays.insert(day) } else { selectedDays.remove(day) }
                            }
                        ))
                        .disabled(!safeTimeManager.canUpdateSafeTime)
                    }
                }

                Section {
                    Button("Save Safe Time") {
                        safeTimeManager.safeDays = Array(selectedDays).sorted()
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
            selectedDays = Set(safeTimeManager.safeDays)
        }
    }
}
