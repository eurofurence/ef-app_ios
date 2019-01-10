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
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
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
        let expectedDealer = context.makeExpectedDealer(from: dealer)
        let expected = [AlphabetisedDealersGroup(indexingString: "B", dealers: [expectedDealer])]

        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerSearchResults)
    }

    func testMatchDealersByPartialNameMatches() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
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
        let expectedDealer = context.makeExpectedDealer(from: dealer)
        let expected = [AlphabetisedDealersGroup(indexingString: "C", dealers: [expectedDealer])]

        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerSearchResults)
    }

    func testMatchDealersIgnoringCase() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
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
        let expectedDealer = context.makeExpectedDealer(from: dealer)
        let expected = [AlphabetisedDealersGroup(indexingString: "C", dealers: [expectedDealer])]

        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerSearchResults)
    }

    func testMatchDealersByExactAlternateNameButGroupByDisplayName() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
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
        let expectedDealer = context.makeExpectedDealer(from: dealer)
        let expected = [AlphabetisedDealersGroup(indexingString: "C", dealers: [expectedDealer])]

        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerSearchResults)
    }

    func testMatchDealersByPartialAlternateNameButGroupByDisplayName() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
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
        let expectedDealer = context.makeExpectedDealer(from: dealer)
        let expected = [AlphabetisedDealersGroup(indexingString: "C", dealers: [expectedDealer])]

        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerSearchResults)
    }

    func testMatchDealersAlternateNameIgnoringCasingButGroupByDisplayName() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
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
        let expectedDealer = context.makeExpectedDealer(from: dealer)
        let expected = [AlphabetisedDealersGroup(indexingString: "C", dealers: [expectedDealer])]

        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerSearchResults)
    }

    func testNotMatchDealersWithoutAlternateNamesWhenSearchDoesNotMatchPreferredName() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
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
        let expected = [AlphabetisedDealersGroup]()

        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerSearchResults)
    }

}
