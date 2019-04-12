@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenInitialMessagesLoadCompletesWithNoMessages: XCTestCase {

    var context: MessagesPresenterTestContext!

    override func setUp() {
        super.setUp()

        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh()
    }

    func testTheRefreshIndicatorIsHidden() {
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
    }

    func testTheMessagesListAppears() {
        XCTAssertTrue(context.scene.didHideMessages)
    }

    func testTheMessagesListDoesNotHide() {
        XCTAssertFalse(context.scene.didShowMessages)
    }

    func testTheNoMessagesPlaceholderAppears() {
        XCTAssertTrue(context.scene.didShowNoMessagesPlaceholder)
    }

    func testTheNoMessagesPlaceholderIsNotHidden() {
        XCTAssertFalse(context.scene.didHideNoMessagesPlaceholder)
    }

}
