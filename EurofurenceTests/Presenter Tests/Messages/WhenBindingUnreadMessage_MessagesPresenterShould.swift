@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenBindingUnreadMessage_MessagesPresenterShould: XCTestCase {
    
    func testTheSceneIsToldToShowUnreadIndicatorForUnreadMessage() {
        var allMessages = [StubMessage].random
        let randomIndex = Int.random(upperLimit: UInt32(allMessages.count))
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        let randomMessage = allMessages[randomIndex]
        randomMessage.isRead = false
        allMessages[randomIndex] = randomMessage
        
        let service = CapturingPrivateMessagesService(localMessages: allMessages)
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh(messages: allMessages)
        let capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
        
        XCTAssertEqual(capturingMessageScene.unreadIndicatorVisibility, .visible)
    }

}
