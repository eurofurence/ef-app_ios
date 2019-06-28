import EventBus
import Foundation

class NotificationPayloadDecodingContext {
    
    private let payload: [String: String]
    private let completionHandler: (NotificationContent) -> Void
    
    init(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        self.payload = payload
        self.completionHandler = completionHandler
    }
    
    func complete(content: NotificationContent) {
        completionHandler(content)
    }
    
    func value(forPayloadKey key: String) -> String? {
        return payload[key]
    }
    
}

class NotificationPayloadDecoder {
    
    private let nextComponent: NotificationPayloadDecoder?
    
    init(nextComponent: NotificationPayloadDecoder?) {
        self.nextComponent = nextComponent
    }
    
    func process(context: NotificationPayloadDecodingContext) {
        nextComponent?.process(context: context)
    }
    
}

class EventNotificationPayloadDecoder: NotificationPayloadDecoder {
    
    private let eventsService: EventsService
    
    init(nextComponent: NotificationPayloadDecoder?, eventsService: EventsService) {
        self.eventsService = eventsService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationPayloadDecodingContext) {
        if isEventPayload(context) {
            processEventPayload(context)
        } else {
            super.process(context: context)
        }
    }
    
    private func isEventPayload(_ context: NotificationPayloadDecodingContext) -> Bool {
        return context.value(forPayloadKey: ApplicationNotificationKey.notificationContentKind.rawValue) == ApplicationNotificationContentKind.event.rawValue
    }
    
    private func processEventPayload(_ context: NotificationPayloadDecodingContext) {
        let content: NotificationContent = {
            guard let identifier = context.value(forPayloadKey: ApplicationNotificationKey.notificationContentIdentifier.rawValue) else { return .unknown }
            
            let eventIdentifier = EventIdentifier(identifier)
            guard eventsService.fetchEvent(identifier: eventIdentifier) != nil else { return .unknown }
            
            return .event(eventIdentifier)
        }()
        
        context.complete(content: content)
    }
    
}

class MessageNotificationPayloadDecoder: NotificationPayloadDecoder {
    
    private let privateMessagesService: PrivateMessagesService
    
    init(nextComponent: NotificationPayloadDecoder?, privateMessagesService: PrivateMessagesService) {
        self.privateMessagesService = privateMessagesService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationPayloadDecodingContext) {
        if let messageIdentifier = context.value(forPayloadKey: "message_id") {
            let identifier = MessageIdentifier(messageIdentifier)
            if privateMessagesService.fetchMessage(identifiedBy: identifier) != nil {
                context.complete(content: .message(identifier))
                return
            }
        }
        
        super.process(context: context)
    }
    
}

class SyncBeforeContinuingNotificationPayloadDecoder: NotificationPayloadDecoder {
    
    private let refreshService: RefreshService
    
    init(nextComponent: NotificationPayloadDecoder?, refreshService: RefreshService) {
        self.refreshService = refreshService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationPayloadDecodingContext) {
        refreshService.refreshLocalStore { (error) in
            if error == nil {
                super.process(context: context)
            } else {
                context.complete(content: .failedSync)
            }
        }
    }
    
}

class AnnouncementNotificationPayloadDecoder: NotificationPayloadDecoder {
    
    private let announcementsService: AnnouncementsService
    
    init(nextComponent: NotificationPayloadDecoder?, announcementsService: AnnouncementsService) {
        self.announcementsService = announcementsService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationPayloadDecodingContext) {
        if let announcementIdentifier = context.value(forPayloadKey: "announcement_id") {
            processAnnouncement(announcementIdentifier, context: context)
        } else {
            super.process(context: context)
        }
    }
    
    private func processAnnouncement(_ announcementIdentifier: String, context: NotificationPayloadDecodingContext) {
        let identifier = AnnouncementIdentifier(announcementIdentifier)
        if announcementsService.fetchAnnouncement(identifier: identifier) != nil {
            context.complete(content: .announcement(identifier))
        } else {
            context.complete(content: .invalidatedAnnouncement)
        }
    }
    
}

class SuccessfulSyncNotificationPayloadDecoder: NotificationPayloadDecoder {
    
    override func process(context: NotificationPayloadDecodingContext) {
        context.complete(content: .successfulSync)
    }
    
}

struct ConcreteNotificationService: NotificationService {

    var eventBus: EventBus
    var eventsService: EventsService
    var announcementsService: AnnouncementsService
    var refreshService: RefreshService
    var privateMessagesService: PrivateMessagesService
    
    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        let catchAllChainComponent = SuccessfulSyncNotificationPayloadDecoder(nextComponent: nil)
        let findAnnouncement = AnnouncementNotificationPayloadDecoder(nextComponent: catchAllChainComponent, announcementsService: announcementsService)
        let findMessageAfterSyncComponent = MessageNotificationPayloadDecoder(nextComponent: findAnnouncement, privateMessagesService: privateMessagesService)
        let syncComponent = SyncBeforeContinuingNotificationPayloadDecoder(nextComponent: findMessageAfterSyncComponent, refreshService: refreshService)
        let findLocalMessageComponent = MessageNotificationPayloadDecoder(nextComponent: syncComponent, privateMessagesService: privateMessagesService)
        let findLocalEventComponent = EventNotificationPayloadDecoder(nextComponent: findLocalMessageComponent, eventsService: eventsService)
        let context = NotificationPayloadDecodingContext(payload: payload, completionHandler: completionHandler)
        findLocalEventComponent.process(context: context)
    }

    func storeRemoteNotificationsToken(_ deviceToken: Data) {
        eventBus.post(DomainEvent.RemoteNotificationTokenAvailable(deviceToken: deviceToken))
    }

}
