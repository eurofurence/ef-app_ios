import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class MessagesPresenterTestsWhenBindingMessages: XCTestCase {

    func testBindingMessageViewModel() {
        let allMessages = [StubMessage].random
        let randomIndex = Int.random(upperLimit: UInt32(allMessages.count))
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        let message = allMessages[randomIndex]
        
        let service = CapturingPrivateMessagesService(localMessages: allMessages)
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        context.scene.delegate?.messagesSceneReady()
        context.privateMessagesService.succeedLastRefresh(messages: allMessages)
        let capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
        
        let expectedMessageContents = context.markdownRenderer.stubbedContents(for: message.contents)
        
        XCTAssertEqual(allMessages.count, context.scene.boundMessageCount)
        XCTAssertEqual(message.authorName, capturingMessageScene.capturedAuthor)
        XCTAssertEqual(message.subject, capturingMessageScene.capturedSubject)
        XCTAssertEqual(expectedMessageContents, capturingMessageScene.capturedContents)
        XCTAssertEqual(message.receivedDateTime, context.dateFormatter.capturedDate)
        XCTAssertEqual(context.dateFormatter.stubString, capturingMessageScene.capturedReceivedDateTime)
    }
    
    func testUnreadIndicatorState() {
        assertBindingMessage(isRead: false, setsUnreadIndicatorVisibilityTo: .visible)
        assertBindingMessage(isRead: true, setsUnreadIndicatorVisibilityTo: .hidden)
    }
    
    func testMessageTransitionsFromUnreadToRead() {
        let allMessages = [StubMessage].random
        let randomIndex = Int.random(upperLimit: UInt32(allMessages.count))
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        let message = allMessages[randomIndex]
        message.transitionToUnreadState()
        
        let service = CapturingPrivateMessagesService(localMessages: allMessages)
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        context.scene.delegate?.messagesSceneReady()
        context.privateMessagesService.succeedLastRefresh(messages: allMessages)
        
        let capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
        
        XCTAssertEqual(.visible, capturingMessageScene.unreadIndicatorVisibility)
        
        message.transitionToReadState()
        
        XCTAssertEqual(.hidden, capturingMessageScene.unreadIndicatorVisibility)
    }
    
    func testStopUpdatingSceneAfterUnbinding() {
        let allMessages = [StubMessage].random
        let randomIndex = Int.random(upperLimit: UInt32(allMessages.count))
        let randomIndexPath = IndexPath(row: randomIndex, section: 0)
        let message = allMessages[randomIndex]
        message.transitionToUnreadState()
        
        let service = CapturingPrivateMessagesService(localMessages: allMessages)
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser(privateMessagesService: service)
        context.scene.delegate?.messagesSceneReady()
        context.privateMessagesService.succeedLastRefresh(messages: allMessages)
        
        let capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
        
        context.scene.delegate?.messagesSceneFinalizing()
        message.transitionToReadState()
        
        XCTAssertEqual(.visible, capturingMessageScene.unreadIndicatorVisibility)
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
        context.scene.delegate?.messagesSceneReady()
        context.privateMessagesService.succeedLastRefresh(messages: allMessages)
        let capturingMessageScene = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(capturingMessageScene, toMessageAt: randomIndexPath)
        
        XCTAssertEqual(capturingMessageScene.unreadIndicatorVisibility, expected)
    }

}
