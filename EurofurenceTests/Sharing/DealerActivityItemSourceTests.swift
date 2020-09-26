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
    
    func testPlaceholderItemUsesURL() {
        let dealer = FakeDealer.random
        let activityItem = DealerActivityItemSource(dealer: dealer)
        let expected = dealer.makeContentURL()
        let activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let actual = activityItem.activityViewControllerPlaceholderItem(activityController)
        
        XCTAssertEqual(expected, actual as? URL)
    }
    
    func testItemUsesURL() {
        let dealer = FakeDealer.random
        let activityItem = DealerActivityItemSource(dealer: dealer)
        let expected = dealer.makeContentURL()
        let activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let actual = activityItem.activityViewController(activityController, itemForActivityType: nil)
        
        XCTAssertEqual(expected, actual as? URL)
    }

}
