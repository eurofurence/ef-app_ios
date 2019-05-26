@testable import Eurofurence

class NotificationResponseProcessorTestBuilder {
    
    struct Context {
        
        var notificationResponseHandler: NotificationResponseProcessor
        var notificationHandling: FakeApplicationNotificationHandling
        var contentRecipient: CapturingNotificationResponseHandler
        
    }
    
    func build() -> Context {
        let notificationHandling = FakeApplicationNotificationHandling()
        let contentRecipient = CapturingNotificationResponseHandler()
        let notificationResponseHandler = NotificationResponseProcessor(notificationHandling: notificationHandling, contentRecipient: contentRecipient)
        
        return Context(notificationResponseHandler: notificationResponseHandler,
                       notificationHandling: notificationHandling,
                       contentRecipient: contentRecipient)
    }
    
}
