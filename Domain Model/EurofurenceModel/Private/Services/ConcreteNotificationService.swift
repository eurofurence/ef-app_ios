import EventBus
import Foundation

struct ConcreteNotificationService: NotificationService {

    var eventBus: EventBus
    var eventsService: ConcreteEventsService
    var announcementsService: ConcreteAnnouncementsService
    var refreshService: ConcreteRefreshService
    var privateMessagesService: PrivateMessagesService
    
    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        NotificationPayloadHandler(
            payload: payload,
            completionHandler: completionHandler,
            eventsService: eventsService,
            announcementsService: announcementsService,
            refreshService: refreshService,
            privateMessagesService: privateMessagesService
        ).handle()
    }

    func storeRemoteNotificationsToken(_ deviceToken: Data) {
        eventBus.post(DomainEvent.RemoteNotificationTokenAvailable(deviceToken: deviceToken))
    }
    
    private struct NotificationPayloadHandler {
        
        var payload: [String: String]
        var completionHandler: (NotificationContent) -> Void
        var eventsService: ConcreteEventsService
        var announcementsService: ConcreteAnnouncementsService
        var refreshService: ConcreteRefreshService
        var privateMessagesService: PrivateMessagesService
        
        private var isEventPayload: Bool {
            return payload[ApplicationNotificationKey.notificationContentKind.rawValue] == ApplicationNotificationContentKind.event.rawValue
        }
        
        func handle() {
            if handleEventPayload() {
                return
            }
            
            if handleMessagePayload() {
                return
            }
            
            refreshService.refreshLocalStore(completionHandler: refreshDidFinish)
        }
        
        private func handleEventPayload() -> Bool {
            guard isEventPayload else { return false }
            
            let content: NotificationContent = {
                guard let identifier = payload[ApplicationNotificationKey.notificationContentIdentifier.rawValue] else { return .unknown }
                
                let eventIdentifier = EventIdentifier(identifier)
                guard eventsService.fetchEvent(identifier: eventIdentifier) != nil else { return .unknown }
                
                return .event(eventIdentifier)
            }()
            
            completionHandler(content)
            return true
        }
        
        private func handleMessagePayload() -> Bool {
            if let messageIdentifier = payload["message_id"] {
                let identifier = MessageIdentifier(messageIdentifier)
                if privateMessagesService.fetchMessage(identifiedBy: identifier) != nil {
                    completionHandler(.message(identifier))
                    return true
                }
            }
            
            return false
        }
        
        private func refreshDidFinish(_ error: Error?) {
            if handleMessagePayload() {
                return
            }
            
            if error == nil {
                handlePostSyncSuccess()
            } else {
                completionHandler(.failedSync)
            }
        }
        
        private func handlePostSyncSuccess() {
            if handleAnnouncementPayload() {
                return
            }
            
            completionHandler(.successfulSync)
        }
        
        private func handleAnnouncementPayload() -> Bool {
            guard let announcementIdentifier = payload["announcement_id"] else { return false }
            
            let identifier = AnnouncementIdentifier(announcementIdentifier)
            if announcementsService.models.contains(where: { $0.identifier == identifier }) {
                completionHandler(.announcement(identifier))
            } else {
                completionHandler(.invalidatedAnnouncement)
            }
            
            return true
        }
        
    }

}
