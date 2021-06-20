import DealerComponent
import DealersComponent
import EurofurenceModel
import EventDetailComponent
import KnowledgeDetailComponent
import KnowledgeGroupsComponent
import ScheduleComponent
import URLContent
import URLRouteable
import XCTest
import XCTURLRouteable

class EurofurenceURLRouteableTests: URLRouteableTestCase {
    
    func testEvents() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/Events",
            routedVia: EurofurenceURLRouteable.self,
            isDescribedAs: ScheduleRouteable()
        )
    }
    
    func testEvent() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/Events/799d48ce-673e-43fe-8ab1-ca6593fee324",
            routedVia: EurofurenceURLRouteable.self,
            isDescribedAs: EventRouteable(
                identifier: EventIdentifier("799d48ce-673e-43fe-8ab1-ca6593fee324")
            )
        )
    }
    
    func testDealers() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/Dealers",
            routedVia: EurofurenceURLRouteable.self,
            isDescribedAs: DealersRouteable()
        )
    }
    
    func testDealer() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/Dealers/7cc35353-f9ae-4115-b5ec-3fe55ef228f8",
            routedVia: EurofurenceURLRouteable.self,
            isDescribedAs: DealerRouteable(
                identifier: DealerIdentifier("7cc35353-f9ae-4115-b5ec-3fe55ef228f8")
            )
        )
    }
    
    func testKnowledgeGroups() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/KnowledgeGroups",
            routedVia: EurofurenceURLRouteable.self,
            isDescribedAs: KnowledgeGroupsRouteable()
        )
    }
    
    func testKnowledgeEntry() throws {
        try assertURL(
            "https://app.eurofurence.org/EF25/Web/KnowledgeEntries/ba2f31ad-d42a-9e40-2c79-17bb9b2f36f3",
            routedVia: EurofurenceURLRouteable.self,
            isDescribedAs: KnowledgeEntryRouteable(
                identifier: KnowledgeEntryIdentifier("ba2f31ad-d42a-9e40-2c79-17bb9b2f36f3")
            )
        )
    }
    
    func testUnexpectedURL() throws {
        let unknownURLString = "https://app.eurofurence.org/EF25/Web/no_idea"
        try assertURL(
            unknownURLString,
            routedVia: EurofurenceURLRouteable.self,
            isDescribedAs: UnknownURLRouteable(url: try XCTUnwrap(URL(string: unknownURLString)))
        )
    }

}
