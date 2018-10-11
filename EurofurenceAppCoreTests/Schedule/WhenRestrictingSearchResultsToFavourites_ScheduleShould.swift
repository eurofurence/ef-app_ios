//
//  WhenRestrictingSearchResultsToFavourites_ScheduleShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenRestrictingSearchResultsToFavourites_ScheduleShould: XCTestCase {
    
    func testUpdateTheDelegateWithAllTheFavourites() {
        let response = APISyncResponse.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        let expected = response.events.changed.map({ Event.Identifier($0.identifier) })
        dataStore.save(response) { (transaction) in
            expected.forEach(transaction.saveFavouriteEventIdentifier)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let schedule = context.application.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        let searchResultIdentifiers = delegate.capturedSearchResults.map({ $0.identifier })
        
        XCTAssertEqual(Set(expected), Set(searchResultIdentifiers))
    }
    
    func testNotIncludeQueryResultsThatAreNotFavourites() {
        let response = APISyncResponse.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        var favouriteEventIdentifiers = response.events.changed.map({ Event.Identifier($0.identifier) })
        let notAFavourite = favouriteEventIdentifiers.randomElement()
        let nonFavouriteEvent = response.events.changed.first(where: { $0.identifier == notAFavourite.element.rawValue })!
        favouriteEventIdentifiers.remove(at: notAFavourite.index)
        dataStore.save(response) { (transaction) in
            favouriteEventIdentifiers.forEach(transaction.saveFavouriteEventIdentifier)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let schedule = context.application.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        schedule.changeSearchTerm(nonFavouriteEvent.title)
        
        XCTAssertFalse(delegate.capturedSearchResults.contains(where: { $0.identifier == notAFavourite.element }))
    }
    
    func testUpdateDelegateWhenUnfavouritingEvent() {
        let response = APISyncResponse.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        let favourites = response.events.changed.map({ Event.Identifier($0.identifier) })
        let randomFavourite = favourites.randomElement()
        dataStore.save(response) { (transaction) in
            favourites.forEach(transaction.saveFavouriteEventIdentifier)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        let schedule = context.application.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        schedule.setResultsDelegate(delegate)
        schedule.restrictResultsToFavourites()
        context.application.unfavouriteEvent(identifier: randomFavourite.element)
        var expected = favourites
        expected.remove(at: randomFavourite.index)
        let searchResultIdentifiers = delegate.capturedSearchResults.map({ $0.identifier })
        
        XCTAssertEqual(Set(expected), Set(searchResultIdentifiers))
    }
    
}
