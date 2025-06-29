import Foundation
import SwiftUI

class SafeTimeManager: ObservableObject {
    @AppStorage("safeStartHour") var safeStartHour: Int = 9
    @AppStorage("safeEndHour") var safeEndHour: Int = 17
    @AppStorage("safeDays") var safeDaysData: Data = try! JSONEncoder().encode([1, 2, 3, 4, 5]) // Mon–Fri

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
