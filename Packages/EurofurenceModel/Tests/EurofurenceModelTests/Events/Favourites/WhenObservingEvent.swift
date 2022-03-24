import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenObservingEvent: XCTestCase {

    func testTheObserverShouldNotBeStronglyRetained() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let randomEvent = response.events.changed.randomElement().element
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let event = schedule.loadEvent(identifier: EventIdentifier(randomEvent.identifier))
        var observer: CapturingEventObserver? = CapturingEventObserver()
        weak var weakObserver = observer
        event?.add(observer.unsafelyUnwrapped)
        observer = nil
        
        XCTAssertNil(weakObserver)
    }

}
