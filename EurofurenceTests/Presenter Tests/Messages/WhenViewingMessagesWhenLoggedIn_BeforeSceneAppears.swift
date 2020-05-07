@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenViewingMessagesWhenLoggedIn_BeforeSceneAppears: XCTestCase {

    func testTheSceneIsNotToldToShowTheRefreshIndicator() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        XCTAssertEqual(.unset, context.scene.refreshIndicatorVisibility)
    }

}
