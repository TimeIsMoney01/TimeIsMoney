import SwiftUI

/// Screen for configuring the "Safe Time" schedule when phone usage
/// should not incur charges. Users choose a daily start and end time as
/// well as the days of the week the window applies to.
struct SafeTimeSettingsView: View {
    /// Provides access to persisted safe time information.
    @ObservedObject var safeTimeManager: SafeTimeManager

    /// Tracks when the safe time was last changed.
    @AppStorage("lastSafeTimeChangeDate") private var lastSafeTimeChangeDate: Double = 0

    /// Persisted start and end times in seconds since 1970 for the selected window.
    @AppStorage("safeStartTime") private var safeStartTime: Double = 9.0 * 3600.0
    @AppStorage("safeEndTime") private var safeEndTime: Double = 17.0 * 3600.0

    /// Whether at least seven days have passed since the last change.
    private var sevenDaysSinceChange: Bool {
        let elapsed = Date().timeIntervalSince1970 - lastSafeTimeChangeDate
        return elapsed >= 7 * 86_400
    }

    /// The currently chosen start time.
    @State private var selectedStart = Date()
    /// The currently chosen end time.
    @State private var selectedEnd = Date().addingTimeInterval(3600)
    /// The days of the week the safe window is active (1 = Sunday).
    @State private var selectedDays: Set<Int> = []
    /// Whether the confirmation alert is visible.
    @State private var showConfirm = false

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

                // Choose which weekdays the window is active using a compact calendar
                Section(header: Text("Active Days")) {
                    WeekdayCalendarPicker(selection: $selectedDays,
                                          disabled: !safeTimeManager.canUpdateSafeTime)
                }

                // Button to persist selections
                Section {
                    Button("Save Safe Time") {
                        HapticManager.tap()
                        showConfirm = true
                    }
                    .disabled(!safeTimeManager.canUpdateSafeTime)
                }

                if !safeTimeManager.canUpdateSafeTime {
                    // Show a notice when edits are locked
                    Text("You can update your safe time again in \(safeTimeManager.remainingDays) days. Changes are allowed once every 7 days.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle("Safe Time Settings")
            .alert("Save Safe Time?", isPresented: $showConfirm) {
                Button("Confirm") {
                    HapticManager.tap()
                    safeTimeManager.updateSafeSchedule(
                        start: selectedStart,
                        end: selectedEnd,
                        days: Array(selectedDays).sorted()
                    )
                    safeStartTime = selectedStart.timeIntervalSince1970
                    safeEndTime = selectedEnd.timeIntervalSince1970
                    lastSafeTimeChangeDate = Date().timeIntervalSince1970
                    HapticManager.success()
                }
                Button("Cancel", role: .cancel) { HapticManager.tap() }
            } message: {
                Text("This change will be locked for 7 days. Are you sure?")
            }
        }
        .onAppear {
            // Populate selections with previously saved values
            selectedStart = Date(timeIntervalSince1970: safeStartTime)
            selectedEnd = Date(timeIntervalSince1970: safeEndTime)
            selectedDays = Set(safeTimeManager.safeDays)
        }
    }
}
