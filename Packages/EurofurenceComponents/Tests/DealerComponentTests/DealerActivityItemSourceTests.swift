import ComponentBase
import DealerComponent
import EurofurenceModel
import LinkPresentation
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

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
    
    override func assertAgainstLinkMetadata(_ metadata: LPLinkMetadata, activityItem: URLBasedActivityItem) {
        super.assertAgainstLinkMetadata(metadata, activityItem: activityItem)
        
        let dealerItem = unsafeDowncast(activityItem, to: DealerActivityItemSource.self)
        XCTAssertEqual(dealerItem.dealer.preferredName, metadata.title)
    }
    
}
