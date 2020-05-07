import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenInitialMessageLoadCompletesWithMessages: XCTestCase {

    func testEntersViewingMessagesState() {
        super.setUp()

        let message = StubMessage.random
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh(messages: [message])
        
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
        XCTAssertTrue(context.scene.didShowMessages)
        XCTAssertFalse(context.scene.didHideMessages)
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }

}
