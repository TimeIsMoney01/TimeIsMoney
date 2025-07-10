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
                        .background(selection.contains(day) ? ColorTheme.accentOrange : ColorTheme.buttonDarkGray)
                        .foregroundColor(ColorTheme.textWhite)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
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
