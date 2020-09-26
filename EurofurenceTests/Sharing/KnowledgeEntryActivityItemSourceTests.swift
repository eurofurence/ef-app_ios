import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

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

}
