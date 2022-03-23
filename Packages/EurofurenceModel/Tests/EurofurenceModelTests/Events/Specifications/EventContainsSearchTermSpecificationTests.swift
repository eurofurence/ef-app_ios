import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class EventContainsSearchTermSpecificationTests: XCTestCase {
    
    func testTitleContainsSearchTerm() {
        let specification = EventContainsSearchTermSpecification(query: "Fursuit")
        let event = FakeEvent.random
        event.title = "Fursuit Walk"
        
        XCTAssertTrue(specification.isSatisfied(by: event), "Title contains the word in the query")
    }
    
    func testTitleDoesNotContainSearchTerm() {
        let specification = EventContainsSearchTermSpecification(query: "Fursuit")
        let event = FakeEvent.random
        event.title = "Opening Ceremony"
        
        XCTAssertFalse(specification.isSatisfied(by: event), "Title does not contain the word in the query")
    }
    
    func testTitleContainsSearchTerm_CaseInsensitive() {
        let specification = EventContainsSearchTermSpecification(query: "fursuit")
        let event = FakeEvent.random
        event.title = "Fursuit Walk"

        XCTAssertTrue(specification.isSatisfied(by: event), "Title contains the word in a different case in the query")
    }
    
}
