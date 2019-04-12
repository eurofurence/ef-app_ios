import XCTest

class WhenMessagesModuleRequestsUserResolution_DirectorShould: XCTestCase {

    var context: ApplicationDirectorTestBuilder.Context!
    var userResolved: Bool!

    override func setUp() {
        super.setUp()

        context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        context.messages.simulateResolutionForUser({ self.userResolved = $0 })
    }

    func testTellMessagesModuleResolutionFailedWhenLoginCancelled() {
        context.loginModule.simulateLoginCancelled()
        XCTAssertFalse(userResolved)
    }

    func testNotTellMessagesModuleResolutionFailedBeforeCancellation() {
        XCTAssertNil(userResolved)
    }

    func testTellMessagesModuleResolutionSucceededWhenLoginSucceeded() {
        context.loginModule.simulateLoginSucceeded()
        XCTAssertTrue(userResolved)
    }

    func testNotTellMessagesModuleResolutionSucceededBeforeLoginSucceeds() {
        XCTAssertNil(userResolved)
    }

    func testDismissLoginModuleWhenLoginSucceeds() {
        context.loginModule.simulateLoginSucceeded()
        XCTAssertTrue(context.tabModule.stubInterface.didDismissViewController)
    }

}
