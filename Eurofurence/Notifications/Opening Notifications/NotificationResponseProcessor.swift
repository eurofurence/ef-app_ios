import EurofurenceModel

class NotificationResponseProcessor {
    
    private let notificationHandling: NotificationService
    private let contentRecipient: NotificationResponseHandler
    
    init(notificationHandling: NotificationService, contentRecipient: NotificationResponseHandler) {
        self.notificationHandling = notificationHandling
        self.contentRecipient = contentRecipient
    }
    
    func openNotification(_ payload: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        let castedPayloadKeysAndValues = payload.compactMap { (key, value) -> (String, String)? in
            guard let stringKey = key as? String, let stringValue = value as? String else { return nil }
            return (stringKey, stringValue)
        }
        
        let castedPayload = castedPayloadKeysAndValues.reduce(into: [String: String](), { $0[$1.0] = $1.1 })
        
        notificationHandling.handleNotification(payload: castedPayload) { (content) in
            self.processNotificationContent(content)
            completionHandler()
        }
    }
    
    private func processNotificationContent(_ content: NotificationContent) {
        switch content {
        case .announcement(let announcement):
            contentRecipient.handleAnnouncement(announcement)
            
        case .event(let event):
            contentRecipient.handleEvent(event)
            
        case .invalidatedAnnouncement:
            contentRecipient.handleInvalidatedAnnouncement()
            
        default:
            break
        }
    }
    
}
