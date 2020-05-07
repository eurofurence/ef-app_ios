import Eurofurence
import EurofurenceModel
import XCTest

class WhenInitialMessagesLoadCompletesWithNoMessages: XCTestCase {

    func testEntersViewingPlaceholderState() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh()
        
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
        XCTAssertTrue(context.scene.didHideMessages)
        XCTAssertFalse(context.scene.didShowMessages)
        XCTAssertTrue(context.scene.didShowNoMessagesPlaceholder)
        XCTAssertFalse(context.scene.didHideNoMessagesPlaceholder)
    }

}
