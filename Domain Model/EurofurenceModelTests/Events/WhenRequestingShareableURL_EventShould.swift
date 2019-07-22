import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRequestingShareableURL_EventShould: XCTestCase {

    func testPrepareShareableURL() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let event = characteristics.events.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let identifier = EventIdentifier(event.identifier)
        let entity = context.eventsService.fetchEvent(identifier: EventIdentifier(event.identifier))
        var url: URL?
        entity?.makeContentURL(completionHandler: { url = $0 })
        
        XCTAssertEqual(unwrap(URL(string: "event://\(identifier.rawValue)")), url)
    }

}
