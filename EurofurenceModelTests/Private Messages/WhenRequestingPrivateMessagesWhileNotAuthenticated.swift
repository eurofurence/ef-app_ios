import EurofurenceModel
import XCTest

class WhenRequestingPrivateMessagesWhileNotAuthenticated: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var capturingMessagesObserver: CapturingPrivateMessagesObserver!

    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
        capturingMessagesObserver = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(capturingMessagesObserver)
        context.privateMessagesService.refreshMessages()
    }

    func testHandlerShouldBeToldFailedToLoadMessages() {
        XCTAssertTrue(capturingMessagesObserver.wasToldFailedToLoadPrivateMessages)
    }

    func testPrivateMessagesShouldNotBeFetched() {
        XCTAssertFalse(context.api.wasToldToLoadPrivateMessages)
    }

}
