@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenInitialMessageLoadCompletesWithMessages: XCTestCase {

    var context: MessagesPresenterTestContext!
    var message: StubMessage!

    override func setUp() {
        super.setUp()

        message = .random
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.reset()
        context.privateMessagesService.succeedLastRefresh(messages: [message])
    }

    func testTheRefreshIndicatorIsHidden() {
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }

    func testTheMessagesListAppears() {
        XCTAssertTrue(context.scene.didShowMessages)
    }

    func testTheMessagesListDoesNotDisappear() {
        XCTAssertFalse(context.scene.didHideMessages)
    }

    func testTheNoMessagesPlaceholderDisappear() {
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
    }

    func testTheNoMessagesPlaceholderDoesNotAppear() {
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }

}
