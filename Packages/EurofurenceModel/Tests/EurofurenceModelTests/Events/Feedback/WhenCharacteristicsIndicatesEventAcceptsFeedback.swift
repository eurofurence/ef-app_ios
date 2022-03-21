import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenCharacteristicsIndicatesEventAcceptsFeedback: XCTestCase {

    func testTheEventShouldAcceptFeedback() {
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = characteristics.events.changed.randomElement()
        var event = randomEvent.element
        event.isAcceptingFeedback = true
        characteristics.events.changed[randomEvent.index] = event
        let store = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(store).build()
        let schedule = context.services.events.makeEventsSchedule()
        let entity = schedule.fetchEvent(identifier: EventIdentifier(event.identifier))
        
        XCTAssertEqual(true, entity?.isAcceptingFeedback)
    }

}
