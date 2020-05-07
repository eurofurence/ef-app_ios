import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenBindingUnreadMessage_MessagesPresenterShould: XCTestCase {
    
    func testUnreadIndicatorState() {
        assertBindingMessage(isRead: false, setsUnreadIndicatorVisibilityTo: .visible)
        assertBindingMessage(isRead: true, setsUnreadIndicatorVisibilityTo: .hidden)
    }
    
    private func assertBindingMessage(
        isRead: Bool,
        setsUnreadIndicatorVisibilityTo expected: VisibilityState,
        _ line: UInt = #line
    ) {
        var allMessages = [StubMessage].random
        let randomIndex = Int.random(upperLimit: UInt32(allMessages.count))
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        let randomMessage = allMessages[randomIndex]
        randomMessage.isRead = isRead
        allMessages[randomIndex] = randomMessage
        
        let service = CapturingPrivateMessagesService(localMessages: allMessages)
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh(messages: allMessages)
        let capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
        
        XCTAssertEqual(capturingMessageScene.unreadIndicatorVisibility, expected)
    }

}
