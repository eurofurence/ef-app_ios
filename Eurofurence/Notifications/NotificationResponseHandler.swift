import EurofurenceModel

class NotificationResponseHandler {
    
    private let notificationHandling: NotificationService
    private let contentRecipient: ContentRecipient
    
    init(notificationHandling: NotificationService, contentRecipient: ContentRecipient) {
        self.notificationHandling = notificationHandling
        self.contentRecipient = contentRecipient
    }
    
    func openNotification(_ payload: [String: String], completionHandler: @escaping () -> Void) {
        notificationHandling.handleNotification(payload: payload) { (content) in
            self.processNotificationContent(content)
            completionHandler()
        }
    }
    
    private func processNotificationContent(_ content: NotificationContent) {
        switch content {
        case .announcement(let announcement):
            contentRecipient.openAnnouncement(announcement)
            
        case .event(let event):
            contentRecipient.openEvent(event)
            
        case .invalidatedAnnouncement:
            contentRecipient.handleInvalidatedAnnouncement()
            
        default:
            break
        }
    }
    
}
