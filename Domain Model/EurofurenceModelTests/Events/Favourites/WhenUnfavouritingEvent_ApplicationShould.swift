import EurofurenceModel
import XCTest

class WhenUnfavouritingEvent_ApplicationShould: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var identifier: EventIdentifier!
    var observer: CapturingEventsServiceObserver!

    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
        let modelCharacteristics = ModelCharacteristics.randomWithoutDeletions
        observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        let randomEvent = modelCharacteristics.events.changed.randomElement().element
        context.performSuccessfulSync(response: modelCharacteristics)

        identifier = EventIdentifier(randomEvent.identifier)
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.favourite()
        event?.unfavourite()
    }

    func testTellTheDataStoreToDeleteTheEventIdentifier() {
        XCTAssertEqual([], context.dataStore.fetchFavouriteEventIdentifiers())
    }

    func testTellObserversTheEventHasBeenUnfavourited() {
        XCTAssertFalse(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

}
