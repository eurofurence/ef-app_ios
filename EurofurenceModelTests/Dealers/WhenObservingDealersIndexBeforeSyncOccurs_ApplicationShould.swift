//
//  WhenObservingDealersIndexBeforeSyncOccurs_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenObservingDealersIndexBeforeSyncOccurs_ApplicationShould: XCTestCase {

    func testTellTheIndexDelegateChangedToEmptyGroups() {
        let context = EurofurenceSessionTestBuilder().build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)

        XCTAssertTrue(delegate.toldAlphabetisedDealersDidChangeToEmptyValue)
    }

}
