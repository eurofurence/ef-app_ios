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

}
