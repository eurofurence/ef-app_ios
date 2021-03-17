import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenMarkingMessageAsRead: XCTestCase {

    func testItShouldTellTheMarkAsReadAPIToMarkTheIdentifierOfTheMessageAsRead() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        context.privateMessagesService.refreshMessages()
        let identifier = "Message ID"
        var message = MessageCharacteristics.random
        message.identifier = identifier
        context.api.simulateMessagesResponse(response: [message])
        observer.observedMessages.first?.markAsRead()

        XCTAssertEqual(identifier, context.api.messageIdentifierMarkedAsRead)
    }

    func testItShouldSupplyTheUsersAuthenticationTokenToTheMarkAsReadAPI() {
        let authenticationToken = "Some auth token"
        let credential = Credential(
            username: "",
            registrationNumber: 0,
            authenticationToken: authenticationToken,
            tokenExpiryDate: .distantFuture
        )
        
        let context = EurofurenceSessionTestBuilder().with(credential).build()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        context.privateMessagesService.refreshMessages()
        let identifier = "Message ID"
        var message = MessageCharacteristics.random
        message.identifier = identifier
        context.api.simulateMessagesResponse(response: [message])
        observer.observedMessages.first?.markAsRead()

        XCTAssertEqual(authenticationToken, context.api.capturedAuthTokenForMarkingMessageAsRead)
    }

    func testItShouldNotifyObserversUnreadMessageCountChanged() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        context.privateMessagesService.refreshMessages()
        let message = MessageCharacteristics.random
        context.api.simulateMessagesResponse(response: [message])
        let entity = observer.observedMessages.first(where: { $0.identifier.rawValue == message.identifier })
        entity?.markAsRead()

        XCTAssertEqual(0, observer.observedUnreadMessageCount)
    }
    
    func testItShouldTellTheObserver() throws {
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
        receivedMessage.markAsRead()
        
        XCTAssertEqual(.read, messageObserver.currentReadState)
    }
    
    func testItShouldNotTellUnregisteredObservers() throws {
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
        receivedMessage.remove(messageObserver)
        
        receivedMessage.markAsRead()
        
        XCTAssertEqual(.unread, messageObserver.currentReadState)
    }

}
