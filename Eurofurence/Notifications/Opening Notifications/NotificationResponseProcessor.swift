import EurofurenceModel

class NotificationResponseProcessor {
    
    private let notificationHandling: NotificationService
    private let contentRecipient: NotificationResponseHandler
    
    init(notificationHandling: NotificationService, contentRecipient: NotificationResponseHandler) {
        self.notificationHandling = notificationHandling
        self.contentRecipient = contentRecipient
    }
    
    func openNotification(_ payload: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        let notificationKeysAndValues: [String: String] = payload.castingKeysAndValues()
        
        notificationHandling.handleNotification(payload: notificationKeysAndValues) { (content) in
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
