//
//  DealersRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class DealersRemoveAllBeforeInsertTests: XCTestCase {

    func testShouldRemoveAllDealersWhenToldTo() {
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.dealers.removeAllBeforeInsert = true
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let expected = context.makeExpectedAlphabetisedDealers(from: subsequentResponse)
        let index = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        index.setDelegate(delegate)

        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerGroups,
                       "Should have removed original dealers between sync events")
    }

}
