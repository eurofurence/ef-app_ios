import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRequestingShareableURL_DealerShould: XCTestCase {

    func testPrepareShareableURL() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let dealer = characteristics.dealers.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let identifier = DealerIdentifier(dealer.identifier)
        let entity = context.dealersService.fetchDealer(for: identifier)
        var url: URL?
        entity?.resolveShareableURL(completionHandler: { url = $0 })
        
        XCTAssertEqual(unwrap(URL(string: "dealer://\(identifier.rawValue)")), url)
    }

}
