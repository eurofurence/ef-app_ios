import EurofurenceApplicationSession
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class EurofurenceShareableURLFactoryTests: XCTestCase {

    func testSharingEvent() {
        let conventionIdentifier = ConventionIdentifier(identifier: "TEST_IDENTIFIER")
        let factory = EurofurenceShareableURLFactory(conventionIdentifier: conventionIdentifier)
        let eventIdentifier = EventIdentifier("EVENT_IDENTIFIER")
        let expected = URL(string: "https://app.eurofurence.org/TEST_IDENTIFIER/Web/Events/EVENT_IDENTIFIER")
        let actual = factory.makeURL(for: eventIdentifier)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSharingDealer() {
        let conventionIdentifier = ConventionIdentifier(identifier: "TEST_IDENTIFIER")
        let factory = EurofurenceShareableURLFactory(conventionIdentifier: conventionIdentifier)
        let dealerIdentifier = DealerIdentifier("DEALER_IDENTIFIER")
        let expected = URL(string: "https://app.eurofurence.org/TEST_IDENTIFIER/Web/Dealers/DEALER_IDENTIFIER")
        let actual = factory.makeURL(for: dealerIdentifier)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSharingKnowledgeEntry() {
        let conventionIdentifier = ConventionIdentifier(identifier: "TEST_IDENTIFIER")
        let factory = EurofurenceShareableURLFactory(conventionIdentifier: conventionIdentifier)
        let knowledgeEntryIdentifier = KnowledgeEntryIdentifier("ENTRY_IDENTIFIER")
        let expected = URL(string: "https://app.eurofurence.org/TEST_IDENTIFIER/Web/KnowledgeEntries/ENTRY_IDENTIFIER")
        let actual = factory.makeURL(for: knowledgeEntryIdentifier)
        
        XCTAssertEqual(expected, actual)
    }

}
