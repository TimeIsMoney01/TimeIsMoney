import Foundation
import SwiftUI

class SafeTimeManager: ObservableObject {
    @AppStorage("safeStartHour") var safeStartHour: Int = 9
    @AppStorage("safeEndHour") var safeEndHour: Int = 17
    @AppStorage("safeDays") var safeDaysData: Data = try! JSONEncoder().encode([1, 2, 3, 4, 5]) // Mon–Fri
    @AppStorage("lastSafeTimeUpdate") var lastSafeTimeUpdate: Double = 0

    /// Minimum number of days between safe time updates.
    private let minDaysBetweenUpdates = 7

    @Published var currentDate = Date()
    
    var safeDays: [Int] {
        get {
            (try? JSONDecoder().decode([Int].self, from: safeDaysData)) ?? []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                safeDaysData = encoded
            }
        }
    }

    /// The current start time for the safe window represented as a date on
    /// today’s calendar.
    var safeStart: Date {
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        comps.hour = safeStartHour
        comps.minute = 0
        return Calendar.current.date(from: comps) ?? Date()
    }

    /// The current end time for the safe window represented as a date on
    /// today’s calendar.
    var safeEnd: Date {
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        comps.hour = safeEndHour
        comps.minute = 0
        return Calendar.current.date(from: comps) ?? Date()
    }

    /// Indicates whether the user can update the safe time settings based on
    /// the last modification date and ``minDaysBetweenUpdates``.
    var canUpdateSafeTime: Bool {
        let elapsed = Date().timeIntervalSince1970 - lastSafeTimeUpdate
        return elapsed >= Double(minDaysBetweenUpdates) * 86_400
    }

    /// Remaining whole days before the user may update their safe time again.
    var remainingDays: Int {
        let elapsed = Date().timeIntervalSince1970 - lastSafeTimeUpdate
        let remaining = max(0, Double(minDaysBetweenUpdates) * 86_400 - elapsed)
        return Int(ceil(remaining / 86_400))
    }

    /// Updates the start/end hours and active days while tracking the last
    /// modification date. This enforces the one-change-per-week rule.
    func updateSafeSchedule(start: Date, end: Date, days: [Int]) {
        safeStartHour = Calendar.current.component(.hour, from: start)
        safeEndHour = Calendar.current.component(.hour, from: end)
        safeDays = days
        lastSafeTimeUpdate = Date().timeIntervalSince1970
    }

    /// Persists new safe time hours using the existing active days.
    func setSafeTime(start: Date, end: Date) {
        updateSafeSchedule(start: start, end: end, days: safeDays)
    }

    var isInSafeTime: Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        let weekday = calendar.component(.weekday, from: currentDate) // Sunday = 1, Saturday = 7
        return hour >= safeStartHour && hour < safeEndHour && safeDays.contains(weekday)
    }

    func updateCurrentTime() {
        currentDate = Date()
    }
}
