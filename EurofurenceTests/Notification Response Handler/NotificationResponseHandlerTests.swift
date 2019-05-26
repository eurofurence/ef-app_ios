@testable import Eurofurence
import EurofurenceModel
import XCTest

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

protocol ContentRecipient {
    
    func openAnnouncement(_ announcement: AnnouncementIdentifier)
    func openEvent(_ event: EventIdentifier)
    func handleInvalidatedAnnouncement()
    
}

class CapturingContentRecipient: ContentRecipient {
    
    private(set) var openedAnnouncement: AnnouncementIdentifier?
    func openAnnouncement(_ announcement: AnnouncementIdentifier) {
        openedAnnouncement = announcement
    }
    
    private(set) var openedEvent: EventIdentifier?
    func openEvent(_ event: EventIdentifier) {
        openedEvent = event
    }
    
    private(set) var handledInvalidatedAnnouncement = false
    func handleInvalidatedAnnouncement() {
        handledInvalidatedAnnouncement = true
    }
    
}

class NotificationResponseHandlerTests: XCTestCase {
    
    var context: NotificationResponseHandlerTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = NotificationResponseHandlerTestBuilder().build()
    }

    func testInvokeTheCallbackAfterHandlerProcessesNotification() {
        let payload = [String.random: String.random]
        context.notificationHandling.stub(.successfulSync, for: payload)
        var didInvokeHandler = false
        context.notificationResponseHandler.openNotification(payload) { didInvokeHandler = true }
        
        XCTAssertTrue(didInvokeHandler)
    }
    
    func testNotInvokeTheCallbackBeforeHandlerProcessesNotification() {
        let payload = [String.random: String.random]
        var didInvokeHandler = false
        context.notificationResponseHandler.openNotification(payload) { didInvokeHandler = true }
        
        XCTAssertFalse(didInvokeHandler)
    }
    
    func testProcessingAnnouncementNotificationTellsContentRecipientToOpenAnnouncement() {
        let payload = [String.random: String.random]
        let announcement = AnnouncementIdentifier.random
        context.notificationHandling.stub(.announcement(announcement), for: payload)
        context.notificationResponseHandler.openNotification(payload) { }
        
        XCTAssertEqual(announcement, context.contentRecipient.openedAnnouncement)
        XCTAssertFalse(context.contentRecipient.handledInvalidatedAnnouncement)
    }
    
    func testProcessingEventNotificationTellsContentRecipientToOpenEvent() {
        let payload = [String.random: String.random]
        let event = EventIdentifier.random
        context.notificationHandling.stub(.event(event), for: payload)
        context.notificationResponseHandler.openNotification(payload) { }
        
        XCTAssertEqual(event, context.contentRecipient.openedEvent)
    }
    
    func testProcessingInvalidatedAnnouncementsTellContentRecipientToHandleIt() {
        let payload = [String.random: String.random]
        context.notificationHandling.stub(.invalidatedAnnouncement, for: payload)
        context.notificationResponseHandler.openNotification(payload) { }
        
        XCTAssertTrue(context.contentRecipient.handledInvalidatedAnnouncement)
    }

}
