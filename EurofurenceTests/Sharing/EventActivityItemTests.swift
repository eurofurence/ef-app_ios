import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class EventActivityItemTests: XCTestCase {
    
    func testEqualityByEventIdentity() {
        let (firstEvent, secondEvent) = (FakeEvent.random, FakeEvent.random)
        let first = EventActivityItemSource(event: firstEvent)
        let second = EventActivityItemSource(event: secondEvent)
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(second, second)
        XCTAssertNotEqual(first, second)
    }
    
    func testPlaceholderItemUsesURL() {
        let event = FakeEvent.random
        let activityItem = EventActivityItemSource(event: event)
        let expected = event.makeContentURL()
        let activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let actual = activityItem.activityViewControllerPlaceholderItem(activityController)
        
        XCTAssertEqual(expected, actual as? URL)
    }
    
    func testItemUsesURL() {
        let event = FakeEvent.random
        let activityItem = EventActivityItemSource(event: event)
        let expected = event.makeContentURL()
        let activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let actual = activityItem.activityViewController(activityController, itemForActivityType: nil)
        
        XCTAssertEqual(expected, actual as? URL)
    }

}
