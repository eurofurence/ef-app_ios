import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewingMessageWhileLoggedInWithLocalMessage: XCTestCase {

    func testTellTheDelegateToShowTheMessage() {
        let localMessage = StubMessage.random
        let context = MessagesPresenterTestContext.makeTestCaseForUserWithMessages([localMessage])
        context.scene.delegate?.messagesSceneReady()
        context.privateMessagesService.succeedLastRefresh(messages: [localMessage])
        
        context.scene.tapMessage(at: 0)
        XCTAssertEqual(localMessage.identifier, context.delegate.messageToShow)
    }

}
