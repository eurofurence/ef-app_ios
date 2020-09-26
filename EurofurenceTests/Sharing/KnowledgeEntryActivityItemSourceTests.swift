import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class KnowledgeEntryActivityItemSourceTests: XCTestCase {
    
    func testEqualityByEntryIdentity() {
        let (firstEntry, secondEntry) = (FakeKnowledgeEntry.random, FakeKnowledgeEntry.random)
        let first = KnowledgeEntryActivityItemSource(knowledgeEntry: firstEntry)
        let second = KnowledgeEntryActivityItemSource(knowledgeEntry: secondEntry)
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(second, second)
        XCTAssertNotEqual(first, second)
    }

}
