import XCTest

class WhenObservingMessage: XCTestCase {

    func testTheObserverIsWeaklyHeld() throws {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let messagesObserver = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(messagesObserver)
        context.privateMessagesService.refreshMessages()
        context.api.simulateMessagesResponse(response: [.random])
        let receivedMessage = try XCTUnwrap(messagesObserver.observedMessages.first)
        var messageObserver: CapturingPrivateMessageObserver? = CapturingPrivateMessageObserver()
        weak var weakMessageObserver = messageObserver
        receivedMessage.add(messageObserver.unsafelyUnwrapped)
        messageObserver = nil
        
        XCTAssertNil(weakMessageObserver)
    }

}
