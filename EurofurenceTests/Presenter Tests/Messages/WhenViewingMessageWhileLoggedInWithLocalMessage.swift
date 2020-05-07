@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewingMessageWhileLoggedInWithLocalMessage: XCTestCase {

    var context: MessagesPresenterTestContext!
    var localMessage: StubMessage!

    override func setUp() {
        super.setUp()

        localMessage = .random
        context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh(messages: [localMessage])
    }

    func testEntersViewingMessagesState() {
        XCTAssertTrue(context.scene.didShowMessages)
        XCTAssertFalse(context.scene.didHideMessages)
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }

    func testSelectingMessageTellsDelegateToShowTheMessage() {
        context.scene.tapMessage(at: 0)
        XCTAssertEqual(localMessage.identifier, context.delegate.messageToShow)
    }

}
