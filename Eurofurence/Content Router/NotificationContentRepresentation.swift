import EurofurenceModel
import Foundation

public struct NotificationContentRepresentation: ContentRepresentation {
    
    private let payload: NotificationPayload
    
    private struct NotificationPayload: Equatable {
        
        private let userInfo: [AnyHashable: AnyHashable]
        
        init(userInfo: [AnyHashable: Any]) {
            self.userInfo = userInfo as? [AnyHashable: AnyHashable] ?? [:]
        }
        
        func value<T>(for key: AnyHashable) -> T? {
            userInfo[key] as? T
        }
        
    }
    
    public init(userInfo: [AnyHashable: Any]) {
        payload = NotificationPayload(userInfo: userInfo)
    }
    
}

// MARK: - ContentRepresentationDescribing

extension NotificationContentRepresentation: ContentRepresentationDescribing {
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        var chain: PayloadDecoder = AnnouncementPayloadDecoder(next: nil)
        chain = MessagePayloadDecoder(next: chain)
        chain = EventPayloadDecoder(next: chain)
        chain.describe(payload: payload, to: recipient)
    }
    
    private class PayloadDecoder {
        
        private let next: PayloadDecoder?
        
        init(next: PayloadDecoder?) {
            self.next = next
        }
        
        func describe(payload: NotificationPayload, to recipient: ContentRepresentationRecipient) {
            next?.describe(payload: payload, to: recipient)
        }
        
    }
    
    private class EventPayloadDecoder: PayloadDecoder {
        
        override func describe(payload: NotificationPayload, to recipient: ContentRepresentationRecipient) {
            if let rawEventIdentifier: String = payload.value(for: ApplicationNotificationKey.notificationContentIdentifier) {
                let eventIdentifier = EventIdentifier(rawEventIdentifier)
                let eventContent = EventContentRepresentation(identifier: eventIdentifier)
                recipient.receive(eventContent)
            } else {
                super.describe(payload: payload, to: recipient)
            }
        }
        
    }
    
    private class MessagePayloadDecoder: PayloadDecoder {
        
        override func describe(payload: NotificationPayload, to recipient: ContentRepresentationRecipient) {
            if let rawMessageIdentifier: String = payload.value(for: "message_id") {
                let messageIdentifier = MessageIdentifier(rawMessageIdentifier)
                let messageContent = MessageContentRepresentation(identifier: messageIdentifier)
                recipient.receive(messageContent)
            } else {
                super.describe(payload: payload, to: recipient)
            }
        }
        
    }
    
    private class AnnouncementPayloadDecoder: PayloadDecoder {
        
        override func describe(payload: NotificationPayload, to recipient: ContentRepresentationRecipient) {
            if let rawAnnouncementIdentifier: String = payload.value(for: "announcement_id") {
                let announcementIdentifier = AnnouncementIdentifier(rawAnnouncementIdentifier)
                let announcementContent = AnnouncementContentRepresentation(identifier: announcementIdentifier)
                recipient.receive(announcementContent)
            } else {
                super.describe(payload: payload, to: recipient)
            }
        }
        
    }
    
}
