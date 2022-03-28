import EurofurenceModel
import XCTest

class WhenFavouritingThenUnfavouritingEvent: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var event: Event?
    var eventObserver: CapturingEventObserver!

    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
        let modelCharacteristics = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = modelCharacteristics.events.changed.randomElement().element
        context.performSuccessfulSync(response: modelCharacteristics)
        let identifier = EventIdentifier(randomEvent.identifier)
        let schedule = context.services.events.loadSchedule(tag: "Test")
        event = schedule.loadEvent(identifier: identifier)
        eventObserver = CapturingEventObserver()
    }

    private func registerEventObserver() {
        event?.add(eventObserver)
    }

    private func favouriteThenUnfavouriteEvent() {
        event?.favourite()
        event?.unfavourite()
    }

    func testObserversShouldBeToldTheEventIsUnfavourited() {
        registerEventObserver()
        favouriteThenUnfavouriteEvent()

        XCTAssertEqual(eventObserver.eventFavouriteState, .notFavourite)
    }

    func testNewlyAddedObserversShouldNotBeToldTheEventIsFavourited() {
        favouriteThenUnfavouriteEvent()
        registerEventObserver()

        XCTAssertEqual(eventObserver.eventFavouriteState, .notFavourite)
    }

}
