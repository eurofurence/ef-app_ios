import EurofurenceModel
import XCTest

class WhenToldToOpenNotification_ThatRepresentsMessage_NotDownloaded_DownloadFails: XCTestCase {

    func testTheHandlerShouldNotBeGivenTheMessageIdentifier() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        
        let message = MessageCharacteristics.random
        let payload: [String: String] = [
            "message_id": message.identifier
        ]
        
        var result: NotificationContent?
        context.notificationsService.handleNotification(payload: payload) { result = $0 }
        
        context.simulateSyncSuccess(.randomWithoutDeletions)
        context.api.simulateMessagesFailure()
        
        XCTAssertEqual(.successfulSync, result)
    }

}
