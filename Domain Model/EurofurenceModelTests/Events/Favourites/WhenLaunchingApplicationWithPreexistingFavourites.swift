import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLaunchingApplicationWithPreexistingFavourites: XCTestCase {

    func testTheObserversAreToldAboutTheFavouritedEvents() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let expected = characteristics.events.changed.map({ EventIdentifier($0.identifier) })
        let dataStore = InMemoryDataStore(response: characteristics)
        dataStore.performTransaction { (transaction) in
            expected.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        XCTAssertTrue(expected.contains(elementsFrom: observer.capturedFavouriteEventIdentifiers))
    }

    func testTheFavouritesAreSortedByEventStartTime() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = InMemoryDataStore(response: response)
        dataStore.performTransaction { (transaction) in
            events.map({ EventIdentifier($0.identifier) }).forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        let expected = events.sorted(by: { $0.startDateTime < $1.startDateTime }).map({ EventIdentifier($0.identifier) })

        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }

}