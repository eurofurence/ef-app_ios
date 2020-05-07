import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class MessagesPresenterTestsWhenBindingMessages: XCTestCase {

    func testBindingMessageViewModel() {
        let allMessages = [StubMessage].random
        let randomIndex = Int.random(upperLimit: UInt32(allMessages.count))
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        let message = allMessages[randomIndex]
        
        let service = CapturingPrivateMessagesService(localMessages: allMessages)
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh(messages: allMessages)
        let capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
        
        XCTAssertEqual(allMessages.count, context.scene.boundMessageCount)
        XCTAssertEqual(message.authorName, capturingMessageScene.capturedAuthor)
        XCTAssertEqual(message.subject, capturingMessageScene.capturedSubject)
        XCTAssertEqual(message.contents, capturingMessageScene.capturedContents)
        XCTAssertEqual(message.receivedDateTime, context.dateFormatter.capturedDate)
        XCTAssertEqual(context.dateFormatter.stubString, capturingMessageScene.capturedReceivedDateTime)
    }

}
