import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDescribingAppLink_WithValidEventIdentifier: XCTestCase {

    func testTheEventIdentifierIsProvided() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let event = characteristics.events.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: characteristics)
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/Events/\(event.identifier)"
        guard let url = URL(string: urlString) else { fatalError("\(urlString) didn't make it into a URL") }
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertEqual(EventIdentifier(event.identifier), visitor.visitedEvent)
    }

}
