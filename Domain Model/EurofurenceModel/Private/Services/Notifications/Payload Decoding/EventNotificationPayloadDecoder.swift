import Foundation

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
