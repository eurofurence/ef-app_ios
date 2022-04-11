import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenCharacteristicsIndicatesEventDoesNotAcceptFeedback: XCTestCase {

    func testTheEventShouldNotAcceptFeedback() {
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = characteristics.events.changed.randomElement()
        var event = randomEvent.element
        event.isAcceptingFeedback = false
        characteristics.events.changed[randomEvent.index] = event
        let store = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(store).build()
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let entity = schedule.loadEvent(identifier: EventIdentifier(event.identifier))
        
        XCTAssertEqual(false, entity?.isAcceptingFeedback)
    }

}
