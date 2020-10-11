import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRemovingFavouritesRestrictionForEvents_ScheduleShould: XCTestCase {

    func testUpdateTheDelegateWithEmptyResults() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let favourites = response.events.changed.map({ EventIdentifier($0.identifier) })
        let dataStore = InMemoryDataStore(response: response)
        dataStore.performTransaction { (transaction) in
            favourites.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        schedule.removeFavouritesEventsRestriction()

        XCTAssertTrue(delegate.capturedSearchResults.isEmpty)
    }

    func testIncludeNonFavouritesInSearchResultsWhenQueryChanges() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let changedEvents = response.events.changed
        var favourites = response.events.changed.map({ EventIdentifier($0.identifier) })
        let notAFavourite = favourites.randomElement()
        let notAFavouriteIdentifier = notAFavourite.element.rawValue
        let nonFavouriteEvent = try XCTUnwrap(changedEvents.first(where: { $0.identifier == notAFavouriteIdentifier }))
        favourites.remove(at: notAFavourite.index)
        let dataStore = InMemoryDataStore(response: response)
        dataStore.performTransaction { (transaction) in
            favourites.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        schedule.removeFavouritesEventsRestriction()

        schedule.changeSearchTerm(nonFavouriteEvent.title)

        XCTAssertTrue(delegate.capturedSearchResults.contains(where: { $0.identifier == notAFavourite.element }))
    }

}
