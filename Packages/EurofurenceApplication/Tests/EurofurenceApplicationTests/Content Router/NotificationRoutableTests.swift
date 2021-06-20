import EurofurenceApplication
import EurofurenceModel
import EventDetailComponent
import RouterCore
import XCTComponentBase
import XCTest
import XCTRouter

class NotificationRouteableTests: RouteableTestCase {
    
    func testEventNotification() {
        let eventIdentifierString = String.random
        assertUserInfo([
            ApplicationNotificationKey.notificationContentKind.rawValue: ApplicationNotificationContentKind.event,
            ApplicationNotificationKey.notificationContentIdentifier.rawValue: eventIdentifierString
        ], isResolvedIntoContent: EventRouteable(identifier: EventIdentifier(eventIdentifierString)))
    }
    
    func testMessageNotification() {
        let messageIdentifierString = String.random
        assertUserInfo(
            ["message_id": messageIdentifierString],
            isResolvedIntoContent: MessageRouteable(
                identifier: MessageIdentifier(messageIdentifierString)
            )
        )
    }
    
    func testAnnouncementNotification() {
        let announcementIdentitiferString = String.random
        assertUserInfo(
            ["announcement_id": announcementIdentitiferString],
            isResolvedIntoContent: AnnouncementRouteable(
                identifier: AnnouncementIdentifier(announcementIdentitiferString)
            )
        )
    }
    
    private func assertUserInfo<Content>(
        _ userInfo: [AnyHashable: Any],
        isResolvedIntoContent expected: Content,
        _ line: UInt = #line
    ) where Content: Routeable {
        let routable = EurofurenceNotificationRouteable(userInfo)
        assert(content: routable, isDescribedAs: expected, line: line)
    }

}
