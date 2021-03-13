import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDescribingAppLink_WithInvalidEventIdentifier: XCTestCase {

    func testTheEventIdentifierIsNotProvided() throws {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: characteristics)
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/Events/thisisntanidentifier"
        let url = try XCTUnwrap(URL(string: urlString))
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertNil(visitor.visitedEvent)
    }

}
