import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DealerActivityItemSourceTests: XCTestCase {

    func testEqualityByDealerIdentity() {
        let (firstDealer, secondDealer) = (FakeDealer.random, FakeDealer.random)
        let first = DealerActivityItemSource(dealer: firstDealer)
        let second = DealerActivityItemSource(dealer: secondDealer)
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(second, second)
        XCTAssertNotEqual(first, second)
    }

}
