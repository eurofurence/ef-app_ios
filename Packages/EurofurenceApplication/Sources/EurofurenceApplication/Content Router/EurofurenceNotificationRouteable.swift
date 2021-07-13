import EurofurenceModel
import EventDetailComponent
import Foundation
import NotificationRouteable
import RouterCore

public class EurofurenceNotificationRouteable: NotificationRouteable {
    
    override public func registerRouteables() {
        super.registerRouteables()
        
        registerNotification(AnnouncementRouteable.self)
        registerNotification(MessageRouteable.self)
        registerNotification(EventRouteable.self)
    }
    
}

extension AnnouncementRouteable: ExpressibleByNotificationPayload {
    
    public init?(notificationPayload: NotificationPayload) {
        guard let rawAnnouncementIdentifier = notificationPayload["announcement_id"] as? String else { return nil }
        
        let announcementIdentifier = AnnouncementIdentifier(rawAnnouncementIdentifier)
        self.init(identifier: announcementIdentifier)
    }
    
}

extension MessageRouteable: ExpressibleByNotificationPayload {
    
    public init?(notificationPayload: NotificationPayload) {
        guard let rawMessageIdentifier = notificationPayload["message_id"] as? String else { return nil }
        
        let messageIdentifier = MessageIdentifier(rawMessageIdentifier)
        self.init(identifier: messageIdentifier)
    }
    
}

extension EventRouteable: ExpressibleByNotificationPayload {
    
    public init?(notificationPayload: NotificationPayload) {
        let contentIdentiferKey = ApplicationNotificationKey.notificationContentIdentifier.rawValue
        guard let rawEventIdentifier = notificationPayload[contentIdentiferKey] as? String else { return nil }
        
        let eventIdentifier = EventIdentifier(rawEventIdentifier)
        self.init(identifier: eventIdentifier)
    }
    
}
