import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

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
        let credential = Credential(username: "", registrationNumber: 0, authenticationToken: authenticationToken, tokenExpiryDate: .distantFuture)
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
        let entity = observer.observedMessages.first(where: { $0.identifier == message.identifier })!
        entity.markAsRead()

        XCTAssertEqual(0, observer.observedUnreadMessageCount)
    }

}
