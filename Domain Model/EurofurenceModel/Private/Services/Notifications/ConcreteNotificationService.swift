import EventBus
import Foundation

struct ConcreteNotificationService: NotificationService {

    var eventBus: EventBus

    func storeRemoteNotificationsToken(_ deviceToken: Data) {
        eventBus.post(
            DomainEvent.RemoteNotificationTokenAvailable(deviceToken: deviceToken)
        )
    }

}
