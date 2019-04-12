import EurofurenceModelTestDoubles
import XCTest

class BeforeMessagesViewAppears_MessagesPresenterShould: XCTestCase {

    func testNotTellTheSceneToPrepareMessagesForPresentation() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.privateMessagesService.succeedLastRefresh(messages: [StubMessage].random)

        XCTAssertFalse(context.scene.didShowMessages)
    }

}
