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
        
        let dealers: [APIDealer] = syncResponse.dealers.changed
        let indexTitles = dealers.map({ String($0.displayName.first!) })
        var dealersByIndexBuckets = [String : [Dealer2]]()
        for title in indexTitles {
            let dealersInBucket = dealers.filter({ $0.displayName.hasPrefix(title) }).sorted(by: { $0.displayName < $1.displayName }).map(context.makeExpectedDealer)
            dealersByIndexBuckets[title] = dealersInBucket
        }
        
        let expected = dealersByIndexBuckets.sorted(by: { $0.key < $1.key }).map { (arg) -> AlphabetisedDealersGroup in
            let (title, dealers) = arg
            return AlphabetisedDealersGroup(indexingString: title, dealers: dealers)
        }
        
        XCTAssertEqual(expected, delegate.capturedAlphabetisedDealerGroups)
    }
    
}
