@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class MessagesPresenterTestsWhenBindingMessages: XCTestCase {

    var context: MessagesPresenterTestContext!
    var allMessages: [StubMessage]!
    var message: Message!
    var capturingMessageScene: CapturingMessageItemScene!

    override func setUp() {
        super.setUp()
        
        allMessages = .random
        let randomIndex = Int.random(upperLimit: UInt32(allMessages.count))
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        self.message = allMessages[randomIndex]
        
        let service = CapturingPrivateMessagesService(localMessages: allMessages)
        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh(messages: allMessages)
        capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
    }

    func testBindTheNumberOfMessagesToTheScene() {
        XCTAssertEqual(allMessages.count, context.scene.boundMessageCount)
    }
    
    func testBindTheMessageAttributesToTheComponent() {
        XCTAssertEqual(message.authorName, capturingMessageScene.capturedAuthor)
        XCTAssertEqual(message.subject, capturingMessageScene.capturedSubject)
        XCTAssertEqual(message.contents, capturingMessageScene.capturedContents)
        XCTAssertEqual(message.receivedDateTime, context.dateFormatter.capturedDate)
        XCTAssertEqual(context.dateFormatter.stubString, capturingMessageScene.capturedReceivedDateTime)
    }

}
