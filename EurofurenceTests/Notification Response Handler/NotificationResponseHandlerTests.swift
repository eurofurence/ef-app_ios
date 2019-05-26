@testable import Eurofurence
import EurofurenceModel
import XCTest

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
