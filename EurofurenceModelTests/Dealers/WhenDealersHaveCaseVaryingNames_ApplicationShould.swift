//
//  WhenDealersHaveCaseVaryingNames_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDealersHaveCaseVaryingNames_ApplicationShould: XCTestCase {

    func testGroupThemTogetherUsingTheCapitalForm() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var firstDealer = DealerCharacteristics.random
        firstDealer.displayName = "Barry"
        var secondDealer = DealerCharacteristics.random
        secondDealer.displayName = "barry"
        syncResponse.dealers.changed = [firstDealer, secondDealer]
        let dataStore = FakeDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let group = delegate.capturedAlphabetisedDealerGroups.first

        XCTAssertEqual("B", group?.indexingString)
        XCTAssertEqual(2, group?.dealers.count)
    }

}
