import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToOpenNotification_ThatRepresentsEventReminder_ApplicationShould: XCTestCase {

    func testNotRefreshTheLocalStore() {
        let context = EurofurenceSessionTestBuilder().build()
        let payload: [String: String] = [
            ApplicationNotificationKey.notificationContentKind.rawValue: ApplicationNotificationContentKind.event.rawValue,
            ApplicationNotificationKey.notificationContentIdentifier.rawValue: String.random
        ]

        context.notificationsService.handleNotification(payload: payload) { (_) in }

        XCTAssertFalse(context.api.didBeginSync)
    }

    func testProvideEventIdentifierInCompletionHandler() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let event = syncResponse.events.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let payload: [String: String] = [
            ApplicationNotificationKey.notificationContentKind.rawValue: ApplicationNotificationContentKind.event.rawValue,
            ApplicationNotificationKey.notificationContentIdentifier.rawValue: event.identifier
        ]

        var result: NotificationContent?
        context.notificationsService.handleNotification(payload: payload) { result = $0 }

        XCTAssertEqual(NotificationContent.event(EventIdentifier(event.identifier)), result)
    }

    func testProvideUnknownActionWhenMissingContentIdentifierKey() {
        let context = EurofurenceSessionTestBuilder().build()
        let payload: [String: String] = [
            ApplicationNotificationKey.notificationContentKind.rawValue: ApplicationNotificationContentKind.event.rawValue
        ]

        var result: NotificationContent?
        context.notificationsService.handleNotification(payload: payload) { result = $0 }

        XCTAssertEqual(NotificationContent.unknown, result)
    }

    func testProvideUnknownActionWhenEventWithIdentifierDoesNotExistWithinStore() {
        let context = EurofurenceSessionTestBuilder().build()
        let payload: [String: String] = [
            ApplicationNotificationKey.notificationContentKind.rawValue: ApplicationNotificationContentKind.event.rawValue,
            ApplicationNotificationKey.notificationContentIdentifier.rawValue: String.random
        ]

        var result: NotificationContent?
        context.notificationsService.handleNotification(payload: payload) { result = $0 }

        XCTAssertEqual(NotificationContent.unknown, result)
    }

}
