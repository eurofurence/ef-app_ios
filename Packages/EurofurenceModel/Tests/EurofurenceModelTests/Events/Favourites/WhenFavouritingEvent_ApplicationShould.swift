import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenFavouritingEvent_ApplicationShould: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var events: [EventCharacteristics]!

    override func setUp() {
        super.setUp()

        let response = ModelCharacteristics.randomWithoutDeletions
        events = response.events.changed
        let dataStore = InMemoryDataStore(response: response)

        context = EurofurenceSessionTestBuilder().with(dataStore).build()
    }

    func testTellTheDataStoreToSaveTheEventIdentifier() {
        let randomEvent = events.randomElement().element
        let identifier = EventIdentifier(randomEvent.identifier)
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.favourite()

        XCTAssertTrue([identifier].contains(elementsFrom: context.dataStore.fetchFavouriteEventIdentifiers()))
    }

    func testTellEventsObserversTheEventIsNowFavourited() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.favourite()

        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

    func testTellLateAddedObserversAboutTheFavouritedEvent() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let observer = CapturingEventsServiceObserver()
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.favourite()
        context.eventsService.add(observer)

        XCTAssertTrue(observer.capturedFavouriteEventIdentifiers.contains(identifier))
    }

    func testTellEventObserverItIsNowFavourited() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let observer = CapturingEventObserver()
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.add(observer)
        event?.favourite()

        XCTAssertEqual(observer.eventFavouriteState, .favourite)
    }

    func testOrganiseTheFavouritesInTitleOrder() {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let storedFavourites = events.map({ EventIdentifier($0.identifier) })
        storedFavourites.filter({ $0 != identifier }).compactMap(context.eventsService.fetchEvent).forEach { (event) in
            event.favourite()
        }

        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        let event = context.eventsService.fetchEvent(identifier: identifier)
        event?.favourite()
        let expected = events.sorted(by: { $0.title < $1.title }).map({ EventIdentifier($0.identifier) })

        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }
    
    func testIndicateTheEventIsAFavourite() throws {
        let identifier = EventIdentifier(events.randomElement().element.identifier)
        let event = try XCTUnwrap(context.eventsService.fetchEvent(identifier: identifier))
        
        XCTAssertFalse(event.isFavourite)
        
        event.favourite()
        
        XCTAssertTrue(event.isFavourite)
    }

}
