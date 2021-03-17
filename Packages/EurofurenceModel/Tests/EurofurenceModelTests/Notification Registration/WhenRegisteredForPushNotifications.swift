import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenRegisteredForPushNotifications: XCTestCase {

    func testTheApplicationTellsTheRemoteNotificationRegistrationItRegisteredWithTheDeviceToken() {
        let context = EurofurenceSessionTestBuilder().build()
        let deviceToken = Data()
        context.notificationsService.storeRemoteNotificationsToken(deviceToken)

        XCTAssertEqual(deviceToken, context.notificationTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }

}
