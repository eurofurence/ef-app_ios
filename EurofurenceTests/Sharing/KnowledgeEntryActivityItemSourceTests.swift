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
    
    func testPlaceholderItemUsesURL() {
        let entry = FakeKnowledgeEntry.random
        let activityItem = KnowledgeEntryActivityItemSource(knowledgeEntry: entry)
        let expected = entry.makeContentURL()
        let activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let actual = activityItem.activityViewControllerPlaceholderItem(activityController)
        
        XCTAssertEqual(expected, actual as? URL)
    }
    
    func testItemUsesURL() {
        let entry = FakeKnowledgeEntry.random
        let activityItem = KnowledgeEntryActivityItemSource(knowledgeEntry: entry)
        let expected = entry.makeContentURL()
        let activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        let actual = activityItem.activityViewController(activityController, itemForActivityType: nil)
        
        XCTAssertEqual(expected, actual as? URL)
    }

}
