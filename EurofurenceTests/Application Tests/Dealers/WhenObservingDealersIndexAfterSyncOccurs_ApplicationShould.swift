//
//  WhenObservingDealersIndexAfterSyncOccurs_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenObservingDealersIndexAfterSyncOccurs_ApplicationShould: XCTestCase {
    
    func testUpdateTheDelegateWithDealersGroupedByDisplayName() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let dealersIndex = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let expected = context.makeExpectedAlphabetisedDealers(from: syncResponse)
        
        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerGroups)
    }
    
}
