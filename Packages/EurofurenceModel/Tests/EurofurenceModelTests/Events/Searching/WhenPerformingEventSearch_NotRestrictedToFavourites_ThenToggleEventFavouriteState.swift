import EurofurenceModel
import XCTest

class WhenPerformingEventSearch_NotRestrictedToFavourites_ThenToggleEventFavouriteState: XCTestCase {

    func testTheSearchResultsAreNotRegenerated() {
        let context = EurofurenceSessionTestBuilder().build()
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let eventBeingSearched = characteristics.events.changed.randomElement().element
        context.performSuccessfulSync(response: characteristics)
        let eventSearchController = context.eventsService.makeEventsSearchController()
        eventSearchController.changeSearchTerm(eventBeingSearched.title)
        let searchControllerDelegate = CapturingEventsSearchControllerDelegate()
        eventSearchController.setResultsDelegate(searchControllerDelegate)
        let schedule = context.services.events.loadSchedule()
        let entity = schedule.loadEvent(identifier: EventIdentifier(eventBeingSearched.identifier))
        entity?.favourite()
        entity?.unfavourite()
        
        XCTAssertTrue(
            searchControllerDelegate.capturedSearchResults.isEmpty,
            "Favouriting an event in the search controller without restricting to the favourites should not " +
            "regenerate the results"
        )
    }

}
