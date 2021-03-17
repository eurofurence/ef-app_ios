import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenRemovingFavouritesRestrictionForEvents_WhileQueryActive_ScheduleShould: XCTestCase {

    func testUpdateTheDelegateWithMatchesForQuery() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let changedEvents = response.events.changed
        var favourites = response.events.changed.map({ EventIdentifier($0.identifier) })
        let (notAFavouriteIndex, notAFavourite) = favourites.randomElement()
        let nonFavouriteEvent = try XCTUnwrap(changedEvents.first(where: { $0.identifier == notAFavourite.rawValue }))
        favourites.remove(at: notAFavouriteIndex)
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

        XCTAssertTrue(delegate.capturedSearchResults.contains(where: { $0.identifier == notAFavourite }))
    }

}
