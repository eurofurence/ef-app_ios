import EventBus
import Foundation

class NotificationContentDecodingContext {
    
    let payload: [String: String]
    private let completionHandler: (NotificationContent) -> Void
    
    init(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        self.payload = payload
        self.completionHandler = completionHandler
    }
    
    func complete(content: NotificationContent) {
        completionHandler(content)
    }
    
}

class NotificationContentDecodingChainComponent {
    
    private let nextComponent: NotificationContentDecodingChainComponent?
    
    init(nextComponent: NotificationContentDecodingChainComponent?) {
        self.nextComponent = nextComponent
    }
    
    func process(context: NotificationContentDecodingContext) {
        nextComponent?.process(context: context)
    }
    
}

class EventNotificationContentDecodingChainComponent: NotificationContentDecodingChainComponent {
    
    private let eventsService: EventsService
    
    init(nextComponent: NotificationContentDecodingChainComponent?, eventsService: EventsService) {
        self.eventsService = eventsService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationContentDecodingContext) {
        if isEventPayload(context) {
            processEventPayload(context)
        } else {
            super.process(context: context)
        }
    }
    
    private func isEventPayload(_ context: NotificationContentDecodingContext) -> Bool {
        return context.payload[ApplicationNotificationKey.notificationContentKind.rawValue] == ApplicationNotificationContentKind.event.rawValue
    }
    
    private func processEventPayload(_ context: NotificationContentDecodingContext) {
        let content: NotificationContent = {
            guard let identifier = context.payload[ApplicationNotificationKey.notificationContentIdentifier.rawValue] else { return .unknown }
            
            let eventIdentifier = EventIdentifier(identifier)
            guard eventsService.fetchEvent(identifier: eventIdentifier) != nil else { return .unknown }
            
            return .event(eventIdentifier)
        }()
        
        context.complete(content: content)
    }
    
}

class MessageNotificationContentDecodingChainComponent: NotificationContentDecodingChainComponent {
    
    private let privateMessagesService: PrivateMessagesService
    
    init(nextComponent: NotificationContentDecodingChainComponent?, privateMessagesService: PrivateMessagesService) {
        self.privateMessagesService = privateMessagesService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationContentDecodingContext) {
        if let messageIdentifier = context.payload["message_id"] {
            let identifier = MessageIdentifier(messageIdentifier)
            if privateMessagesService.fetchMessage(identifiedBy: identifier) != nil {
                context.complete(content: .message(identifier))
                return
            }
        }
        
        super.process(context: context)
    }
    
}

class SyncBeforeContinuingNotificationContentDecodingChainComponent: NotificationContentDecodingChainComponent {
    
    private let refreshService: RefreshService
    
    init(nextComponent: NotificationContentDecodingChainComponent?, refreshService: RefreshService) {
        self.refreshService = refreshService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationContentDecodingContext) {
        refreshService.refreshLocalStore { (error) in
            if error == nil {
                super.process(context: context)
            } else {
                context.complete(content: .failedSync)
            }
        }
    }
    
}

class AnnouncementNotificationContentDecodingChainComponent: NotificationContentDecodingChainComponent {
    
    private let announcementsService: AnnouncementsService
    
    init(nextComponent: NotificationContentDecodingChainComponent?, announcementsService: AnnouncementsService) {
        self.announcementsService = announcementsService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationContentDecodingContext) {
        if let announcementIdentifier = context.payload["announcement_id"] {
            processAnnouncement(announcementIdentifier, context: context)
        } else {
            super.process(context: context)
        }
    }
    
    private func processAnnouncement(_ announcementIdentifier: String, context: NotificationContentDecodingContext) {
        let identifier = AnnouncementIdentifier(announcementIdentifier)
        if announcementsService.fetchAnnouncement(identifier: identifier) != nil {
            context.complete(content: .announcement(identifier))
        } else {
            context.complete(content: .invalidatedAnnouncement)
        }
    }
    
}

class SuccessfulSyncNotificationContentDecodingChainComponent: NotificationContentDecodingChainComponent {
    
    override func process(context: NotificationContentDecodingContext) {
        context.complete(content: .successfulSync)
    }
    
}

struct ConcreteNotificationService: NotificationService {

    var eventBus: EventBus
    var eventsService: ConcreteEventsService
    var announcementsService: ConcreteAnnouncementsService
    var refreshService: ConcreteRefreshService
    var privateMessagesService: PrivateMessagesService
    
    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        let catchAllChainComponent = SuccessfulSyncNotificationContentDecodingChainComponent(nextComponent: nil)
        let findAnnouncement = AnnouncementNotificationContentDecodingChainComponent(nextComponent: catchAllChainComponent, announcementsService: announcementsService)
        let findMessageAfterSyncComponent = MessageNotificationContentDecodingChainComponent(nextComponent: findAnnouncement, privateMessagesService: privateMessagesService)
        let syncComponent = SyncBeforeContinuingNotificationContentDecodingChainComponent(nextComponent: findMessageAfterSyncComponent, refreshService: refreshService)
        let findLocalMessageComponent = MessageNotificationContentDecodingChainComponent(nextComponent: syncComponent, privateMessagesService: privateMessagesService)
        let findLocalEventComponent = EventNotificationContentDecodingChainComponent(nextComponent: findLocalMessageComponent, eventsService: eventsService)
        let context = NotificationContentDecodingContext(payload: payload, completionHandler: completionHandler)
        findLocalEventComponent.process(context: context)
    }

    func storeRemoteNotificationsToken(_ deviceToken: Data) {
        eventBus.post(DomainEvent.RemoteNotificationTokenAvailable(deviceToken: deviceToken))
    }

}
