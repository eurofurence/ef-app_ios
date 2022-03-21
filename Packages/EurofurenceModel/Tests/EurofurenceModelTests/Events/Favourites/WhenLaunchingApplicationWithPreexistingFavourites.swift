import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenLaunchingApplicationWithPreexistingFavourites: XCTestCase {

    func testTheObserversAreToldAboutTheFavouritedEvents() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let expected = characteristics.events.changed.map({ EventIdentifier($0.identifier) })
        let dataStore = InMemoryDataStore(response: characteristics)
        dataStore.performTransaction { (transaction) in
            expected.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer)

        XCTAssertTrue(expected.contains(elementsFrom: observer.capturedFavouriteEventIdentifiers))
    }

    func testTheFavouritesAreSortedByTitle() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let events = response.events.changed
        let dataStore = InMemoryDataStore(response: response)
        dataStore.performTransaction { (transaction) in
            events.map({ EventIdentifier($0.identifier) }).forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer)

        let expected = events.sorted(by: { $0.title < $1.title }).map({ EventIdentifier($0.identifier) })

        XCTAssertEqual(expected, observer.capturedFavouriteEventIdentifiers)
    }

}
