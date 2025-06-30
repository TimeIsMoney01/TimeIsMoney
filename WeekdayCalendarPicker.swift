import SwiftUI

/// A compact calendar-like control for toggling the days a schedule is active.
struct WeekdayCalendarPicker: View {
    /// Bound set of selected weekday numbers (1 = Sunday).
    @Binding var selection: Set<Int>
    /// Whether user interactions are disabled.
    var disabled: Bool = false

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(1...7, id: \.self) { day in
                let symbol = Calendar.current.shortWeekdaySymbols[day - 1]
                Button(action: {
                    triggerLightHaptic()
                    toggle(day)
                }) {
                    Text(symbol)
                        .frame(maxWidth: .infinity, minHeight: 32)
                        .padding(4)
                        .background(selection.contains(day) ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .disabled(disabled)
            }
        }
    }

    private func toggle(_ day: Int) {
        if selection.contains(day) {
            selection.remove(day)
        } else {
            selection.insert(day)
        }
    }
}
