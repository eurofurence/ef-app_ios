@testable import Eurofurence

class NotificationResponseHandlerTestBuilder {
    
    struct Context {
        
        var notificationResponseHandler: NotificationResponseHandler
        var notificationHandling: FakeApplicationNotificationHandling
        var contentRecipient: CapturingContentRecipient
        
    }
    
    func build() -> Context {
        let notificationHandling = FakeApplicationNotificationHandling()
        let contentRecipient = CapturingContentRecipient()
        let notificationResponseHandler = NotificationResponseHandler(notificationHandling: notificationHandling, contentRecipient: contentRecipient)
        
        return Context(notificationResponseHandler: notificationResponseHandler,
                       notificationHandling: notificationHandling,
                       contentRecipient: contentRecipient)
    }
    
}
