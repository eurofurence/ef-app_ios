import Eurofurence
import EurofurenceModel
import XCTest

public struct NotificationContentRepresentation: ContentRepresentation {
    
    private let payload: NotificationPayload
    
    private struct NotificationPayload: Equatable {
        
        private let userInfo: [AnyHashable: AnyHashable]
        
        init(userInfo: [AnyHashable: Any]) {
            self.userInfo = userInfo as? [AnyHashable: AnyHashable] ?? [:]
        }
        
        func value<T>(for key: AnyHashable) -> T? {
            userInfo[key] as? T
        }
        
    }
    
    public init(userInfo: [AnyHashable: Any]) {
        payload = NotificationPayload(userInfo: userInfo)
    }
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        if let rawEventIdentifier: String = payload.value(for: ApplicationNotificationKey.notificationContentIdentifier) {
            let eventIdentifier = EventIdentifier(rawEventIdentifier)
            let eventContent = EventContentRepresentation(identifier: eventIdentifier)
            recipient.receive(eventContent)
        }
        
        if let rawMessageIdentifier: String = payload.value(for: "message_id") {
            let messageIdentifier = MessageIdentifier(rawMessageIdentifier)
            let messageContent = MessageContentRepresentation(identifier: messageIdentifier)
            recipient.receive(messageContent)
        }
        
        if let rawAnnouncementIdentifier: String = payload.value(for: "announcement_id") {
            let announcementIdentifier = AnnouncementIdentifier(rawAnnouncementIdentifier)
            let announcementContent = AnnouncementContentRepresentation(identifier: announcementIdentifier)
            recipient.receive(announcementContent)
        }
    }
    
}

class NotificationContentRepresentationTests: XCTestCase {
    
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
        let recipient = CapturingContentRepresentationRecipient()
        contentRepresentation.describe(to: recipient)
        
        XCTAssertEqual(expected.eraseToAnyContentRepresentation(), recipient.erasedRoutedContent, line: line)
    }

}
