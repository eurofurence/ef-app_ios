import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DealerActivityItemSourceTests: URLBasedActivityItemTestCase {
    
    override func makeActivityItem() throws -> URLBasedActivityItem {
        DealerActivityItemSource(dealer: FakeDealer.random)
    }

    func testEqualityByDealerIdentity() throws {
        let (first, second) = (try makeActivityItem(), try makeActivityItem())
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(second, second)
        XCTAssertNotEqual(first, second)
    }
    
}
