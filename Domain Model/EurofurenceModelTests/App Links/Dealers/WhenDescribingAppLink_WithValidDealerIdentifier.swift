import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDescribingAppLink_WithValidDealerIdentifier: XCTestCase {

    func testTheDealerIdentifierIsProvided() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let dealer = characteristics.dealers.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: characteristics)
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/Dealers/\(dealer.identifier)"
        guard let url = URL(string: urlString) else { fatalError("\(urlString) didn't make it into a URL") }
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertEqual(DealerIdentifier(dealer.identifier), visitor.visitedDealer)
    }

}
