//
//  WhenObservingDealersAfterLoadingFromStore_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenObservingDealersAfterLoadingFromStore_ApplicationShould: XCTestCase {

    func testUpdateTheDelegateWithDealersGroupedByDisplayName() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let expected = context.makeExpectedAlphabetisedDealers(from: syncResponse)

        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerGroups)
    }

}
