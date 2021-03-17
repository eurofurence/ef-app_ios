import ComponentBase
import EurofurenceApplication
import EurofurenceModel
import LinkPresentation
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class KnowledgeEntryActivityItemSourceTests: URLBasedActivityItemTestCase {
    
    override func makeActivityItem() throws -> URLBasedActivityItem {
        KnowledgeEntryActivityItemSource(knowledgeEntry: FakeKnowledgeEntry.random)
    }

    func testEqualityByEntryIdentity() throws {
        let (first, second) = (try makeActivityItem(), try makeActivityItem())
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(second, second)
        XCTAssertNotEqual(first, second)
    }
    
    @available(iOS 13.0, *)
    override func assertAgainstLinkMetadata(_ metadata: LPLinkMetadata, activityItem: URLBasedActivityItem) {
        super.assertAgainstLinkMetadata(metadata, activityItem: activityItem)
        
        let knowledgeEntryItem = unsafeDowncast(activityItem, to: KnowledgeEntryActivityItemSource.self)
        XCTAssertEqual(knowledgeEntryItem.knowledgeEntry.title, metadata.title)
    }

}
