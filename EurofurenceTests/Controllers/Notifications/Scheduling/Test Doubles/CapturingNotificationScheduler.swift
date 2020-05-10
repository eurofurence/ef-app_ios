@testable import Eurofurence
import EurofurenceModel
import Foundation

class CapturingNotificationScheduler: NotificationScheduler {

    private(set) var capturedEventIdentifier: EventIdentifier?
    private(set) var capturedEventNotificationScheduledDateComponents: DateComponents?
    private(set) var capturedEventNotificationTitle: String?
    private(set) var capturedEventNotificationBody: String?
    private(set) var capturedEventNotificationUserInfo: [ApplicationNotificationKey: String] = [:]
    func scheduleNotification(forEvent identifier: EventIdentifier,
                              at dateComponents: DateComponents,
                              title: String,
                              body: String,
                              userInfo: [ApplicationNotificationKey: String]) {
        capturedEventIdentifier = identifier
        capturedEventNotificationScheduledDateComponents = dateComponents
        capturedEventNotificationTitle = title
        capturedEventNotificationBody = body
        capturedEventNotificationUserInfo = userInfo
    }

    private(set) var capturedEventIdentifierToRemoveNotification: EventIdentifier?
    func cancelNotification(forEvent identifier: EventIdentifier) {
        capturedEventIdentifierToRemoveNotification = identifier
    }

}
