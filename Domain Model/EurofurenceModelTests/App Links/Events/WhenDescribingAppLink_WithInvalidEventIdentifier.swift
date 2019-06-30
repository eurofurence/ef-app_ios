import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDescribingAppLink_WithInvalidEventIdentifier: XCTestCase {

    func testTheEventIdentifierIsNotProvided() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: characteristics)
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/Events/thisisntanidentifier"
        guard let url = URL(string: urlString) else { fatalError("\(urlString) didn't make it into a URL") }
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertNil(visitor.visitedEvent)
    }

}
