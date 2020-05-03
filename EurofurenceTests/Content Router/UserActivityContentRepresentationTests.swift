import Eurofurence
import XCTest

class UserActivityContentRepresentationTests: XCTestCase {
    
    func testIntent() {
        let intent = "View Some Content"
        let intentDescription = IntentActivityDescription(intent: intent)
        let contentRepresentation = UserActivityContentRepresentation(activity: intentDescription)
        let expected = IntentContentRepresentation(intent: intent)
        
        let recipient = CapturingContentRepresentationRecipient()
        contentRepresentation.describe(to: recipient)
        XCTAssertEqual(expected.eraseToAnyContentRepresentation(), recipient.erasedRoutedContent)
    }
    
    func testURL() {
        let url = URL.random
        let intentDescription = URLActivityDescription(url: url)
        let contentRepresentation = UserActivityContentRepresentation(activity: intentDescription)
        let expected = URLContentRepresentation(url: url)
        
        let recipient = CapturingContentRepresentationRecipient()
        contentRepresentation.describe(to: recipient)
        XCTAssertEqual(expected.eraseToAnyContentRepresentation(), recipient.erasedRoutedContent)
    }

}
