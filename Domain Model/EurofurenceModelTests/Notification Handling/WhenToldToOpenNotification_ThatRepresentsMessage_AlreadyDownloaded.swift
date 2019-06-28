import EurofurenceModel
import XCTest

class WhenToldToOpenNotification_ThatRepresentsMessage: XCTestCase {

    func testTheHandlerShouldBeGivenTheMessageIdentifierWithoutSyncNeeded() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let message = MessageCharacteristics.random
        context.privateMessagesService.refreshMessages()
        context.api.simulateMessagesResponse(response: [message])
        
        let payload: [String: String] = [
            "message_id": message.identifier
        ]
        
        var result: NotificationContent?
        context.notificationsService.handleNotification(payload: payload) { result = $0 }
        
        XCTAssertEqual(NotificationContent.message(MessageIdentifier(message.identifier)), result)
        XCTAssertFalse(context.api.didBeginSync)
    }

}
