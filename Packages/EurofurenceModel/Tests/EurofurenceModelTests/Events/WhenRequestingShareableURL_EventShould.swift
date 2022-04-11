import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenRequestingShareableURL_EventShould: XCTestCase {

    func testPrepareShareableURL() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let event = characteristics.events.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let identifier = EventIdentifier(event.identifier)
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let entity = schedule.loadEvent(identifier: EventIdentifier(event.identifier))
        let url = entity?.contentURL
        
        XCTAssertEqual(URL(string: "event://\(identifier.rawValue)").unsafelyUnwrapped, url)
    }

}
