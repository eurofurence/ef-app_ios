import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenDescribingAppLink_WithValidDealerIdentifier: XCTestCase {

    func testTheDealerIdentifierIsProvided() throws {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let dealer = characteristics.dealers.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: characteristics)
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/Dealers/\(dealer.identifier)"
        let url = try XCTUnwrap(URL(string: urlString))
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertEqual(DealerIdentifier(dealer.identifier), visitor.visitedDealer)
    }

}
