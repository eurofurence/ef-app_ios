import Foundation
import EurofurenceModel

public protocol NotificationScheduler {

    func scheduleNotification(forEvent identifier: EventIdentifier,
                              at dateComponents: DateComponents,
                              title: String,
                              body: String,
                              userInfo: [ApplicationNotificationKey: String])
    func cancelNotification(forEvent identifier: EventIdentifier)

}
