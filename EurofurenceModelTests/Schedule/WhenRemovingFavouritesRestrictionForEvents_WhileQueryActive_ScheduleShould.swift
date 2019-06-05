import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRemovingFavouritesRestrictionForEvents_WhileQueryActive_ScheduleShould: XCTestCase {

    func testUpdateTheDelegateWithMatchesForQuery() {
        let response = ModelCharacteristics.randomWithoutDeletions
        var favourites = response.events.changed.map({ EventIdentifier($0.identifier) })
        let notAFavourite = favourites.randomElement()
        let nonFavouriteEvent = unwrap(response.events.changed.first(where: { $0.identifier == notAFavourite.element.rawValue }))
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
        schedule.changeSearchTerm(nonFavouriteEvent.title)
        schedule.removeFavouritesEventsRestriction()

        XCTAssertTrue(delegate.capturedSearchResults.contains(where: { $0.identifier == notAFavourite.element }))
    }

}
