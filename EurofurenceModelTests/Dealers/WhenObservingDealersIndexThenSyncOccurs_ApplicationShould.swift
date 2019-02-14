//
//  WhenObservingDealersIndexThenSyncOccurs_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenObservingDealersIndexThenSyncOccurs_ApplicationShould: XCTestCase {

    func testUpdateTheDelegateWithDealersGroupedByDisplayName() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        context.performSuccessfulSync(response: syncResponse)

        AlphabetisedDealersGroupAssertion(groups: delegate.capturedAlphabetisedDealerGroups,
                                          fromDealerCharacteristics: syncResponse.dealers.changed).assertGroups()
    }

}
