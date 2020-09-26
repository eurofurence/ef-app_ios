import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class EventActivityItemTests: URLBasedActivityItemTestCase {
    
    override func makeActivityItem() throws -> URLBasedActivityItem {
        EventActivityItemSource(event: FakeEvent.random)
    }

    func testEqualityByEventIdentity() throws {
        let (first, second) = (try makeActivityItem(), try makeActivityItem())
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(second, second)
        XCTAssertNotEqual(first, second)
    }

}
