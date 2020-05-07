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
        context.scene.delegate?.messagesSceneReady()
        context.privateMessagesService.succeedLastRefresh(messages: [localMessage])
    }

    func testSelectingMessageTellsDelegateToShowTheMessage() {
        context.scene.tapMessage(at: 0)
        XCTAssertEqual(localMessage.identifier, context.delegate.messageToShow)
    }

}
