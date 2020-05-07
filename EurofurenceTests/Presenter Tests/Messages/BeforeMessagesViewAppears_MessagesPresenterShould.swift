import EurofurenceModelTestDoubles
import XCTest

class BeforeMessagesViewAppears_MessagesPresenterShould: XCTestCase {

    func testNotPerformAnySceneMutations() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()

        XCTAssertEqual(.unset, context.scene.refreshIndicatorVisibility)
        XCTAssertEqual(.unset, context.scene.messagesListVisibility)
    }

}
