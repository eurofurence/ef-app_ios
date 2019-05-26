@testable import Eurofurence
import EurofurenceModel
import XCTest

class NotificationResponseHandler {
    
    private let notificationHandling: NotificationService
    
    init(notificationHandling: NotificationService) {
        self.notificationHandling = notificationHandling
    }
    
    func openNotification(_ payload: [String: String], completionHandler: @escaping () -> Void) {
        notificationHandling.handleNotification(payload: payload) { (_) in
            completionHandler()
        }
    }
    
}

class NotificationResponseHandlerTestBuilder {
    
    struct Context {
        
        var notificationResponseHandler: NotificationResponseHandler
        var notificationHandling: FakeApplicationNotificationHandling
        
    }
    
    func build() -> Context {
        let notificationHandling = FakeApplicationNotificationHandling()
        let notificationResponseHandler = NotificationResponseHandler(notificationHandling: notificationHandling)
        
        return Context(notificationResponseHandler: notificationResponseHandler,
                       notificationHandling: notificationHandling)
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

}
