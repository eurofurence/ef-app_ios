import Eurofurence
import EurofurenceModel
import XCTest

public struct NotificationContentRepresentation: ContentRepresentation {
    
    public var userInfo: [AnyHashable: AnyHashable]
    
    public init(userInfo: [AnyHashable: Any]) {
        self.userInfo = userInfo as? [AnyHashable: AnyHashable] ?? [:]
    }
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        if let rawEventIdentifier = userInfo[ApplicationNotificationKey.notificationContentIdentifier] as? String {
            let eventIdentifier = EventIdentifier(rawEventIdentifier)
            let eventContent = EventContentRepresentation(identifier: eventIdentifier)
            recipient.receive(eventContent)
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
        let userInfo: [AnyHashable: Any] = [
            ApplicationNotificationKey.notificationContentKind: ApplicationNotificationContentKind.event,
            ApplicationNotificationKey.notificationContentIdentifier: eventIdentifierString
        ]
        
        let contentRepresentation = NotificationContentRepresentation(userInfo: userInfo)
        let recipient = CapturingContentRepresentationRecipient()
        contentRepresentation.describe(to: recipient)
        
        let expected = EventContentRepresentation(identifier: EventIdentifier(eventIdentifierString))
        XCTAssertEqual(expected.eraseToAnyContentRepresentation(), recipient.erasedRoutedContent)
    }

}
