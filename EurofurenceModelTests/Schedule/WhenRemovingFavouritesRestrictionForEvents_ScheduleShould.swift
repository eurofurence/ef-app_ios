import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRemovingFavouritesRestrictionForEvents_ScheduleShould: XCTestCase {

    func testUpdateTheDelegateWithEmptyResults() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let favourites = response.events.changed.map({ EventIdentifier($0.identifier) })
        let dataStore = FakeDataStore(response: response)
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

    func testIncludeNonFavouritesInSearchResultsWhenQueryChanges() {
        let response = ModelCharacteristics.randomWithoutDeletions
        var favourites = response.events.changed.map({ EventIdentifier($0.identifier) })
        let notAFavourite = favourites.randomElement()
        let nonFavouriteEvent = response.events.changed.first(where: { $0.identifier == notAFavourite.element.rawValue })!
        favourites.remove(at: notAFavourite.index)
        let dataStore = FakeDataStore(response: response)
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
