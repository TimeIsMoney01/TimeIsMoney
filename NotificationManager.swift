import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    /// Schedules a repeating notification 5 minutes before the Safe Time window
    /// ends on the given weekdays.
    func scheduleSafeTimeEndReminder(endHour: Int, days: [Int]) {
        let center = UNUserNotificationCenter.current()

        // Remove any existing Safe Time notifications
        let ids = (1...7).map { "safeTimeEnd-\($0)" }
        center.removePendingNotificationRequests(withIdentifiers: ids)

        let calendar = Calendar.current
        for day in days {
            var comps = DateComponents()
            comps.weekday = day
            comps.hour = endHour
            comps.minute = 0

            guard let next = calendar.nextDate(after: Date(), matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents),
                  let triggerDate = calendar.date(byAdding: .minute, value: -5, to: next) else { continue }

            let triggerComps = calendar.dateComponents([.weekday, .hour, .minute], from: triggerDate)

            let content = UNMutableNotificationContent()
            content.title = "Safe Time Ending Soon"
            content.body = "Your Safe Time ends in 5 minutes."
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComps, repeats: true)
            let request = UNNotificationRequest(identifier: "safeTimeEnd-\(day)", content: content, trigger: trigger)
            center.add(request)
        }
    }

    /// Immediately delivers a notification that the user has reached half of
    /// their daily limit for the given app.
    func notifyHalfLimitReached(for app: String) {
        scheduleImmediate(title: "Halfway There", body: "You've used half of your \(app) limit today.")
    }

    /// Immediately delivers a notification that the daily limit for the given
    /// app has been reached.
    func notifyLimitReached(for app: String) {
        scheduleImmediate(title: "Limit Reached", body: "You've reached your daily \(app) limit.")
    }

    /// Helper to schedule a notification firing almost immediately.
    private func scheduleImmediate(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
