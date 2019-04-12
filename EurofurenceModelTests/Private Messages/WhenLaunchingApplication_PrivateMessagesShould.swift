import EurofurenceModel
import XCTest

class WhenLaunchingApplication_PrivateMessagesShould: XCTestCase {

    func testBeRefreshed() {
        let message = MessageCharacteristics.random
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        context.api.simulateMessagesResponse(response: [message])
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        let observedMessage = observer.observedMessages.first

        XCTAssertEqual(message.authorName, observedMessage?.authorName)
        XCTAssertEqual(message.receivedDateTime, observedMessage?.receivedDateTime)
        XCTAssertEqual(message.subject, observedMessage?.subject)
        XCTAssertEqual(message.contents, observedMessage?.contents)
        XCTAssertEqual(message.isRead, observedMessage?.isRead)
    }

    func testProvideZeroCountForNumberOfUnreadPrivateMessages() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)

        XCTAssertEqual(0, observer.observedUnreadMessageCount)
    }

}
