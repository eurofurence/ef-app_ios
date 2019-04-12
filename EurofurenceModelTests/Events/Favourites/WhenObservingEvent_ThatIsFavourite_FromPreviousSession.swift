import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenObservingEvent_ThatIsFavourite_FromPreviousSession: XCTestCase {

    func testTheObserverShouldBeToldTheEventIsFavourited() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = response.events.changed.randomElement().element
        let dataStore = FakeDataStore(response: response)
        let eventIdentifier: EventIdentifier = EventIdentifier(randomEvent.identifier)
        dataStore.performTransaction { (transaction) in
            transaction.saveFavouriteEventIdentifier(eventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let event = context.eventsService.fetchEvent(identifier: eventIdentifier)
        let observer = CapturingEventObserver()
        event?.add(observer)

        XCTAssertEqual(observer.eventFavouriteState, .favourite)
    }

}
