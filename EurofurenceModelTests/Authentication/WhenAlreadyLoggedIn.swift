import EurofurenceModel
import XCTest

class WhenAlreadyLoggedIn: XCTestCase {

    func testSubsequentLoginsIgnoredAndToldLoginSucceeded() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let loginObserver = CapturingLoginObserver()
        context.login(completionHandler: loginObserver.completionHandler)

        XCTAssertTrue(loginObserver.notifiedLoginSucceeded)
        XCTAssertNil(context.api.capturedLoginRequest)
    }

}
