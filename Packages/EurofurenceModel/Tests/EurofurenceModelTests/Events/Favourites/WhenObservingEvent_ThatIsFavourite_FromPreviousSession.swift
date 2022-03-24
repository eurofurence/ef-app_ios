import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenObservingEvent_ThatIsFavourite_FromPreviousSession: XCTestCase {

    func testTheObserverShouldBeToldTheEventIsFavourited() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = response.events.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: response)
        let eventIdentifier: EventIdentifier = EventIdentifier(randomEvent.identifier)
        dataStore.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(eventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.services.events.loadSchedule(tag: "Test")
        let event = schedule.loadEvent(identifier: eventIdentifier)
        let observer = CapturingEventObserver()
        event?.add(observer)

        XCTAssertEqual(observer.eventFavouriteState, .favourite)
    }

}
