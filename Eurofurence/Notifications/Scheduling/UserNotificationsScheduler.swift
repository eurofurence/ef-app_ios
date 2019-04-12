import EurofurenceModel
import UserNotifications

struct UserNotificationsScheduler: NotificationScheduler {

    func scheduleNotification(forEvent identifier: EventIdentifier,
                              at dateComponents: DateComponents,
                              title: String,
                              body: String,
                              userInfo: [ApplicationNotificationKey: String]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = userInfo.xpcSafeDictionary

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier.rawValue, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to add notification with error: \(error)")
            }
        }
    }

    func cancelNotification(forEvent identifier: EventIdentifier) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier.rawValue])
    }

}

private extension Dictionary where Key == ApplicationNotificationKey, Value == String {

    var xpcSafeDictionary: [String: String] {
        let stringPairs: [(String, String)] = map({ (key, value) -> (String, String) in
            return (key.rawValue, value)
        })

        var dictionary = [String: String]()
        for (key, value) in stringPairs {
            dictionary[key] = value
        }
        
        return dictionary
    }

}
