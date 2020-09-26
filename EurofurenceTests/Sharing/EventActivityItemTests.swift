import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import LinkPresentation
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
    
    @available(iOS 13.0, *)
    override func assertAgainstLinkMetadata(_ metadata: LPLinkMetadata, activityItem: URLBasedActivityItem) {
        super.assertAgainstLinkMetadata(metadata, activityItem: activityItem)
        
        let eventItem = unsafeDowncast(activityItem, to: EventActivityItemSource.self)
        XCTAssertEqual(eventItem.event.title, metadata.title)
    }

}
