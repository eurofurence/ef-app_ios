import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenObservingEvent_ThatIsFavourite: XCTestCase {

    func testTheObserverShouldBeToldTheEventIsFavourited() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let randomEvent = response.events.changed.randomElement().element
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let event = schedule.loadEvent(identifier: EventIdentifier(randomEvent.identifier))
        event?.favourite()

        let observer = CapturingEventObserver()
        event?.add(observer)

        XCTAssertEqual(observer.eventFavouriteState, .favourite)
    }

}
