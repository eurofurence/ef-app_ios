import EurofurenceModel
import XCTest

class WhenLoggingOut_ThenRequestingPrivateMessages: XCTestCase {

    func testNoRequestIsMade() {
        let context = EurofurenceSessionTestBuilder().build()
        context.loginSuccessfully()
        context.logoutSuccessfully()
        context.privateMessagesService.refreshMessages()
        
        XCTAssertEqual(
            1,
            context.api.privateMessagesLoadCount,
            "Messages should only be requested on initial login, and not subsequent load requests when logged out"
        )
    }

}
