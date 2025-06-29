import SwiftUI

/// Screen for configuring the "Safe Time" schedule when phone usage
/// should not incur charges. Users choose a daily start and end time as
/// well as the days of the week the window applies to.
struct SafeTimeSettingsView: View {
    /// Provides access to persisted safe time information.
    @ObservedObject var safeTimeManager: SafeTimeManager
    /// The currently chosen start time.
    @State private var selectedStart = Date()
    /// The currently chosen end time.
    @State private var selectedEnd = Date().addingTimeInterval(3600)

    /// The days of the week the safe window is active (1 = Sunday).


    @State private var selectedDays: Set<Int> = []

    var body: some View {
        NavigationView {
            Form {
                // Pick the hours during which usage is free
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

                // Choose which weekdays the window is active
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

                // Button to persist selections
                Section {
                    Button("Save Safe Time") {
                        safeTimeManager.safeDays = Array(selectedDays).sorted()
                        safeTimeManager.setSafeTime(start: selectedStart, end: selectedEnd)
                    }
                    .disabled(!safeTimeManager.canUpdateSafeTime)
                }

                if !safeTimeManager.canUpdateSafeTime {
                    // Show a notice when edits are locked
                    Text("You can update your safe time again in \(safeTimeManager.remainingDays) days.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle("Safe Time Settings")
        }
        .onAppear {
            // Populate selections with previously saved values
            selectedStart = safeTimeManager.safeStart
            selectedEnd = safeTimeManager.safeEnd
            selectedDays = Set(safeTimeManager.safeDays)
        }
    }
}
