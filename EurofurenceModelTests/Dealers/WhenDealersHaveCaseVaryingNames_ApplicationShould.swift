//
//  WhenDealersHaveCaseVaryingNames_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenDealersHaveCaseVaryingNames_ApplicationShould: XCTestCase {

    func testGroupThemTogetherUsingTheCapitalForm() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var firstDealer = APIDealer.random
        firstDealer.displayName = "Barry"
        var secondDealer = APIDealer.random
        secondDealer.displayName = "barry"
        syncResponse.dealers.changed = [firstDealer, secondDealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let group = delegate.capturedAlphabetisedDealerGroups.first

        XCTAssertEqual("B", group?.indexingString)
        XCTAssertEqual(2, group?.dealers.count)
    }

}
