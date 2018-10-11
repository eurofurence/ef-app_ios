//
//  WhenObservingDealersIndexBeforeSyncOccurs_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenObservingDealersIndexBeforeSyncOccurs_ApplicationShould: XCTestCase {

    func testTellTheIndexDelegateChangedToEmptyGroups() {
        let context = ApplicationTestBuilder().build()
        let dealersIndex = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)

        XCTAssertTrue(delegate.toldAlphabetisedDealersDidChangeToEmptyValue)
    }

}
