//
//  WhenTellingDealersIndexToSearch_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenTellingDealersIndexToSearch_ApplicationShould: XCTestCase {

    func testMatchDealersByExactPreferredName() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        let preferredName = "Bob"
        dealer.displayName = preferredName
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        dealersIndex.performSearch(term: preferredName)

        AlphabetisedDealersGroupAssertion(groups: delegate.capturedAlphabetisedDealerSearchResults,
                                          fromDealerCharacteristics: [dealer]).assertGroups()
    }

    func testMatchDealersByPartialNameMatches() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        let preferredName = "Charlie"
        dealer.displayName = preferredName
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        dealersIndex.performSearch(term: "Cha")

        AlphabetisedDealersGroupAssertion(groups: delegate.capturedAlphabetisedDealerSearchResults,
                                          fromDealerCharacteristics: [dealer]).assertGroups()
    }

    func testMatchDealersIgnoringCase() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        let preferredName = "coOL DudE"
        dealer.displayName = preferredName
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        dealersIndex.performSearch(term: "dude")

        AlphabetisedDealersGroupAssertion(groups: delegate.capturedAlphabetisedDealerSearchResults,
                                          fromDealerCharacteristics: [dealer]).assertGroups()
    }

    func testMatchDealersByExactAlternateNameButGroupByDisplayName() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        let attendeeNickname = "Bob"
        dealer.displayName = "Charlie"
        dealer.attendeeNickname = attendeeNickname
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        dealersIndex.performSearch(term: attendeeNickname)

        AlphabetisedDealersGroupAssertion(groups: delegate.capturedAlphabetisedDealerSearchResults,
                                          fromDealerCharacteristics: [dealer]).assertGroups()
    }

    func testMatchDealersByPartialAlternateNameButGroupByDisplayName() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        let attendeeNickname = "Bob"
        dealer.displayName = "Charlie"
        dealer.attendeeNickname = attendeeNickname
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        dealersIndex.performSearch(term: "ob")

        AlphabetisedDealersGroupAssertion(groups: delegate.capturedAlphabetisedDealerSearchResults,
                                          fromDealerCharacteristics: [dealer]).assertGroups()
    }

    func testMatchDealersAlternateNameIgnoringCasingButGroupByDisplayName() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        let attendeeNickname = "Bob"
        dealer.displayName = "Charlie"
        dealer.attendeeNickname = attendeeNickname
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        dealersIndex.performSearch(term: "bob")

        AlphabetisedDealersGroupAssertion(groups: delegate.capturedAlphabetisedDealerSearchResults,
                                          fromDealerCharacteristics: [dealer]).assertGroups()
    }

    func testNotMatchDealersWithoutAlternateNamesWhenSearchDoesNotMatchPreferredName() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.displayName = "Charlie"
        dealer.attendeeNickname = "Charlie"
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        dealersIndex.performSearch(term: "zzzzz")

        XCTAssertTrue(delegate.capturedAlphabetisedDealerSearchResults.isEmpty)
    }

}
