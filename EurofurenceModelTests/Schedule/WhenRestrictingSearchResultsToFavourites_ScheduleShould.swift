import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRestrictingSearchResultsToFavourites_ScheduleShould: XCTestCase {

    func testUpdateTheDelegateWithAllTheFavourites() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: response)
        let expected = response.events.changed.map({ EventIdentifier($0.identifier) })
        
        dataStore.performTransaction { (transaction) in
            expected.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        let searchResultIdentifiers = delegate.capturedSearchResults.map({ $0.identifier })

        XCTAssertEqual(Set(expected), Set(searchResultIdentifiers))
    }

    func testNotIncludeQueryResultsThatAreNotFavourites() {
        let response = ModelCharacteristics.randomWithoutDeletions
        var favouriteEventIdentifiers = response.events.changed.map({ EventIdentifier($0.identifier) })
        let notAFavourite = favouriteEventIdentifiers.randomElement()
        let nonFavouriteEvent = response.events.changed.first(where: { $0.identifier == notAFavourite.element.rawValue })!
        favouriteEventIdentifiers.remove(at: notAFavourite.index)
        let dataStore = InMemoryDataStore(response: response)
        dataStore.performTransaction { (transaction) in
            favouriteEventIdentifiers.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        schedule.changeSearchTerm(nonFavouriteEvent.title)

        XCTAssertFalse(delegate.capturedSearchResults.contains(where: { $0.identifier == notAFavourite.element }))
    }

    func testUpdateDelegateWhenUnfavouritingEvent() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let favourites = response.events.changed.map({ EventIdentifier($0.identifier) })
        let randomFavourite = favourites.randomElement()
        let dataStore = InMemoryDataStore(response: response)
        dataStore.performTransaction { (transaction) in
            favourites.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        let event = context.eventsService.fetchEvent(identifier: randomFavourite.element)
        event?.unfavourite()
        var expected = favourites
        expected.remove(at: randomFavourite.index)
        let searchResultIdentifiers = delegate.capturedSearchResults.map({ $0.identifier })

        XCTAssertEqual(Set(expected), Set(searchResultIdentifiers))
    }

}
