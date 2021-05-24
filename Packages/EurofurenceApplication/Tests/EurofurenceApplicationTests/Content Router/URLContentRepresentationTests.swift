import ComponentBase
import DealerComponent
import DealersComponent
import EurofurenceApplication
import EurofurenceModel
import EventDetailComponent
import KnowledgeDetailComponent
import XCTComponentBase
import XCTest

class URLContentRepresentationTests: ContentRepresentationTestCase {
    
    func testEvent() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/Events/799d48ce-673e-43fe-8ab1-ca6593fee324",
            isDescribedAs: EventContentRepresentation(
                identifier: EventIdentifier("799d48ce-673e-43fe-8ab1-ca6593fee324")
            )
        )
    }
    
    func testDealers() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/Dealers",
            isDescribedAs: DealersContentRepresentation()
        )
    }
    
    func testDealer() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/Dealers/7cc35353-f9ae-4115-b5ec-3fe55ef228f8",
            isDescribedAs: DealerContentRepresentation(
                identifier: DealerIdentifier("7cc35353-f9ae-4115-b5ec-3fe55ef228f8")
            )
        )
    }
    
    func testKnowledgeGroups() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/KnowledgeGroups",
            isDescribedAs: KnowledgeGroupsContentRepresentation()
        )
    }
    
    func testKnowledgeEntry() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/KnowledgeEntries/ba2f31ad-d42a-9e40-2c79-17bb9b2f36f3",
            isDescribedAs: KnowledgeEntryContentRepresentation(
                identifier: KnowledgeEntryIdentifier("ba2f31ad-d42a-9e40-2c79-17bb9b2f36f3")
            )
        )
    }
    
    func testUnexpectedURL() throws {
        try assertNotDescribedAsContent(
            "https://app.eurofurence.org/EF25/Web/no_idea"
        )
    }
    
    private func assertURL<Content>(
        _ urlString: String,
        isDescribedAs expected: Content,
        _ line: UInt = #line
    ) throws where Content: ContentRepresentation {
        let url = try XCTUnwrap(URL(string: urlString))
        
        assert(
            content: URLContentRepresentation(url: url),
            isDescribedAs: expected,
            line: line
        )
    }
    
    private func assertNotDescribedAsContent(
        _ urlString: String,
        _ line: UInt = #line
    ) throws {
        let url = try XCTUnwrap(URL(string: urlString))
        
        assertNoDescription(
            content: URLContentRepresentation(url: url),
            line: line
        )
    }

}
