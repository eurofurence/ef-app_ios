import EurofurenceModel
import UIKit

struct NotificationServiceFetchResultAdapter {

    private let notificationService: NotificationService

    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    func handleRemoteNotification(_ payload: [AnyHashable: Any],
                                  completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let notificationKeysAndValues: [String: String] = payload.castingKeysAndValues()

        notificationService.handleNotification(payload: notificationKeysAndValues) { (content) in
            switch content {
            case .successfulSync:
                completionHandler(.newData)

            case .failedSync:
                completionHandler(.failed)

            case .announcement:
                completionHandler(.newData)

            case .event:
                completionHandler(.noData)

            case .invalidatedAnnouncement:
                completionHandler(.noData)

            case .unknown:
                completionHandler(.noData)
            }
        }
    }

}
