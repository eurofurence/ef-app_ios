import EventBus
import Foundation

struct ConcreteNotificationService: NotificationService {

    var eventBus: EventBus
    var eventsService: EventsService
    var announcementsService: AnnouncementsService
    var refreshService: RefreshService
    var privateMessagesService: PrivateMessagesService
    
    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        let chain = makePayloadDecoderChain()
        let context = NotificationPayloadDecodingContext(payload: payload, completionHandler: completionHandler)
        chain.process(context: context)
    }

    func storeRemoteNotificationsToken(_ deviceToken: Data) {
        eventBus.post(DomainEvent.RemoteNotificationTokenAvailable(deviceToken: deviceToken))
    }
    
    private func makePayloadDecoderChain() -> NotificationPayloadDecoder {
        let catchAllChainComponent = SuccessfulSyncNotificationPayloadDecoder(nextComponent: nil)
        let findAnnouncement = AnnouncementNotificationPayloadDecoder(nextComponent: catchAllChainComponent, announcementsService: announcementsService)
        let findMessageAfterSyncComponent = MessageNotificationPayloadDecoder(nextComponent: findAnnouncement, privateMessagesService: privateMessagesService)
        let syncComponent = SyncBeforeContinuingNotificationPayloadDecoder(nextComponent: findMessageAfterSyncComponent, refreshService: refreshService)
        let findLocalMessageComponent = MessageNotificationPayloadDecoder(nextComponent: syncComponent, privateMessagesService: privateMessagesService)
        let findLocalEventComponent = EventNotificationPayloadDecoder(nextComponent: findLocalMessageComponent, eventsService: eventsService)
        
        return findLocalEventComponent
    }

}
