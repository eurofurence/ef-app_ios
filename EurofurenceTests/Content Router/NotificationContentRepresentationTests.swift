import Eurofurence
import EurofurenceModel
import XCTest

class NotificationContentRepresentationTests: ContentRepresentationTestCase {
    
    func testEquality() {
        let firstPayload: [AnyHashable: Any] = ["A": 1, 2: "B"]
        let secondPayload: [AnyHashable: Any] = ["B": 1, "A": 2]
        let firstNotification = NotificationContentRepresentation(userInfo: firstPayload)
        let secondNotification = NotificationContentRepresentation(userInfo: secondPayload)
        
        XCTAssertEqual(firstNotification, firstNotification)
        XCTAssertNotEqual(firstNotification, secondNotification)
        XCTAssertEqual(secondNotification, secondNotification)
    }
    
    func testEventNotification() {
        let eventIdentifierString = String.random
        assertUserInfo([
            ApplicationNotificationKey.notificationContentKind: ApplicationNotificationContentKind.event,
            ApplicationNotificationKey.notificationContentIdentifier: eventIdentifierString
        ], isResolvedIntoContent: EventContentRepresentation(identifier: EventIdentifier(eventIdentifierString)))
    }
    
    func testMessageNotification() {
        let messageIdentifierString = String.random
        assertUserInfo(
            ["message_id": messageIdentifierString],
            isResolvedIntoContent: MessageContentRepresentation(
                identifier: MessageIdentifier(messageIdentifierString)
            )
        )
    }
    
    func testAnnouncementNotification() {
        let announcementIdentitiferString = String.random
        assertUserInfo(
            ["announcement_id": announcementIdentitiferString],
            isResolvedIntoContent: AnnouncementContentRepresentation(
                identifier: AnnouncementIdentifier(announcementIdentitiferString)
            )
        )
    }
    
    private func assertUserInfo<Content>(
        _ userInfo: [AnyHashable: Any],
        isResolvedIntoContent expected: Content,
        _ line: UInt = #line
    ) where Content: ContentRepresentation {
        let contentRepresentation = NotificationContentRepresentation(userInfo: userInfo)
        assert(content: contentRepresentation, isDescribedAs: expected, line: line)
    }

}
