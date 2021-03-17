import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenObservingUnreadMessage: XCTestCase {

    func testTheObserverShouldBeToldTheMessageIsUnread() throws {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let messagesObserver = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(messagesObserver)
        context.privateMessagesService.refreshMessages()
        let identifier = "Message ID"
        var message = MessageCharacteristics.random
        message.identifier = identifier
        message.isRead = false
        context.api.simulateMessagesResponse(response: [message])
        let receivedMessage = try XCTUnwrap(messagesObserver.observedMessages.first)
        let messageObserver = CapturingPrivateMessageObserver()
        receivedMessage.add(messageObserver)
        
        XCTAssertEqual(.unread, messageObserver.currentReadState)
    }

}
