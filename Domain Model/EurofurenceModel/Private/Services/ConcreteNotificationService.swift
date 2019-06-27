import EventBus
import Foundation

struct ConcreteNotificationService: NotificationService {

    var eventBus: EventBus
    var eventsService: ConcreteEventsService
    var announcementsService: ConcreteAnnouncementsService
    var refreshService: ConcreteRefreshService
    var privateMessagesService: PrivateMessagesService

    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        if payload[ApplicationNotificationKey.notificationContentKind.rawValue] == ApplicationNotificationContentKind.event.rawValue {
            guard let identifier = payload[ApplicationNotificationKey.notificationContentIdentifier.rawValue] else {
                completionHandler(.unknown)
                return
            }

            let eventIdentifier = EventIdentifier(identifier)
            guard eventsService.fetchEvent(identifier: eventIdentifier) != nil else {
                completionHandler(.unknown)
                return
            }

            completionHandler(.event(eventIdentifier))

            return
        }
        
        if let messageIdentifier = payload["message_id"] {
            let identifier = MessageIdentifier(messageIdentifier)
            if privateMessagesService.fetchMessage(identifiedBy: identifier) != nil {   
                completionHandler(.message(identifier))
                return
            }
        }

        refreshService.refreshLocalStore { (error) in
            if let messageIdentifier = payload["message_id"] {
                let identifier = MessageIdentifier(messageIdentifier)
                if self.privateMessagesService.fetchMessage(identifiedBy: identifier) != nil {
                    completionHandler(.message(identifier))
                    return
                }
            }
            
            if error == nil {
                if let announcementIdentifier = payload["announcement_id"] {
                    let identifier = AnnouncementIdentifier(announcementIdentifier)
                    if self.announcementsService.models.contains(where: { $0.identifier == identifier }) {
                        completionHandler(.announcement(identifier))
                    } else {
                        completionHandler(.invalidatedAnnouncement)
                    }
                } else {
                    completionHandler(.successfulSync)
                }
            } else {
                completionHandler(.failedSync)
            }
        }
    }

    func storeRemoteNotificationsToken(_ deviceToken: Data) {
        eventBus.post(DomainEvent.RemoteNotificationTokenAvailable(deviceToken: deviceToken))
    }

}
