import EurofurenceModel
import XCTest

class WhenToldToOpenNotification_ThatRepresentsMessage_NotDownloaded_DownloadSucceeds: XCTestCase {

    func testTheHandlerShouldBeGivenTheMessageIdentifier() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        
        let message = MessageCharacteristics.random
        let payload: [String: String] = [
            "message_id": message.identifier
        ]
        
        var result: NotificationContent?
        context.notificationsService.handleNotification(payload: payload) { result = $0 }
        
        context.simulateSyncSuccess(.randomWithoutDeletions)
        context.api.simulateMessagesResponse(response: [message])
        
        XCTAssertEqual(.message(MessageIdentifier(message.identifier)), result)
    }

}
