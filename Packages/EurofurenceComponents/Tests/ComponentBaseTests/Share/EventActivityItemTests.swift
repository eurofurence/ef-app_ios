import ComponentBase
import EurofurenceModel
import LinkPresentation
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class EventActivityItemTests: URLBasedActivityItemTestCase {
    
    private func makeRandomEventWithoutImages() -> Event {
        let event = FakeEvent.random
        event.posterGraphicPNGData = nil
        event.bannerGraphicPNGData = nil
        
        return event
    }
    
    override func makeActivityItem() throws -> URLBasedActivityItem {
        EventActivityItemSource(event: makeRandomEventWithoutImages())
    }

    func testEqualityByEventIdentity() throws {
        let (first, second) = (try makeActivityItem(), try makeActivityItem())
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(second, second)
        XCTAssertNotEqual(first, second)
    }
    
    func testPosterAvailable() throws {
        let event = FakeEvent.random
        let poster = try XCTUnwrap(UIImage(named: "Event Banner", in: .module, compatibleWith: nil))
        event.bannerGraphicPNGData = try XCTUnwrap(poster.pngData())
        
        let activityItem = EventActivityItemSource(event: event)
        let linkMetadata = self.linkMetadata(from: activityItem)
        
        XCTAssertNotNil(linkMetadata?.imageProvider)
    }
    
    override func assertAgainstLinkMetadata(_ metadata: LPLinkMetadata, activityItem: URLBasedActivityItem) {
        super.assertAgainstLinkMetadata(metadata, activityItem: activityItem)
        
        let eventItem = unsafeDowncast(activityItem, to: EventActivityItemSource.self)
        XCTAssertEqual(eventItem.event.title, metadata.title)
        XCTAssertNil(metadata.imageProvider)
    }

}
