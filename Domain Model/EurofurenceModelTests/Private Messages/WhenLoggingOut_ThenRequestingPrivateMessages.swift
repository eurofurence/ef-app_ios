import EurofurenceModel
import XCTest

class WhenLoggingOut_ThenRequestingPrivateMessages: XCTestCase {

    func testNoRequestIsMade() {
        let context = EurofurenceSessionTestBuilder().build()
        context.loginSuccessfully()
        context.logoutSuccessfully()
        context.privateMessagesService.refreshMessages()
        
        XCTAssertFalse(context.api.wasToldToLoadPrivateMessages)
    }

}
