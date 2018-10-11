//
//  WhenRemovingFavouritesRestrictionForEvents_ScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenRemovingFavouritesRestrictionForEvents_ScheduleShould: XCTestCase {

    func testUpdateTheDelegateWithEmptyResults() {
        let response = APISyncResponse.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        let favourites = response.events.changed.map({ Event.Identifier($0.identifier) })
        dataStore.save(response) { (transaction) in
            favourites.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let schedule = context.application.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        schedule.removeFavouritesEventsRestriction()

        XCTAssertEqual([], delegate.capturedSearchResults)
    }

    func testIncludeNonFavouritesInSearchResultsWhenQueryChanges() {
        let response = APISyncResponse.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        var favourites = response.events.changed.map({ Event.Identifier($0.identifier) })
        let notAFavourite = favourites.randomElement()
        let nonFavouriteEvent = response.events.changed.first(where: { $0.identifier == notAFavourite.element.rawValue })!
        favourites.remove(at: notAFavourite.index)
        dataStore.save(response) { (transaction) in
            favourites.forEach(transaction.saveFavouriteEventIdentifier)
        }

        let context = ApplicationTestBuilder().with(dataStore).build()
        let schedule = context.application.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        schedule.removeFavouritesEventsRestriction()

        schedule.changeSearchTerm(nonFavouriteEvent.title)

        XCTAssertTrue(delegate.capturedSearchResults.contains(where: { $0.identifier == notAFavourite.element }))
    }

}
