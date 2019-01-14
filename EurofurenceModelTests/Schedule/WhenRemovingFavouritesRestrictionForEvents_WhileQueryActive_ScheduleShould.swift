//
//  WhenRemovingFavouritesRestrictionForEvents_WhileQueryActive_ScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenRemovingFavouritesRestrictionForEvents_WhileQueryActive_ScheduleShould: XCTestCase {

    func testUpdateTheDelegateWithMatchesForQuery() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        var favourites = response.events.changed.map({ EventIdentifier($0.identifier) })
        let notAFavourite = favourites.randomElement()
        let nonFavouriteEvent = response.events.changed.first(where: { $0.identifier == notAFavourite.element.rawValue })!
        favourites.remove(at: notAFavourite.index)
        dataStore.save(response) { (transaction) in
            favourites.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let schedule = context.eventsService.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        schedule.changeSearchTerm(nonFavouriteEvent.title)
        schedule.removeFavouritesEventsRestriction()

        XCTAssertTrue(delegate.capturedSearchResults.contains(where: { $0.identifier == notAFavourite.element }))
    }

}
