//
//  WhenDeletingDealer_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class WhenDeletingDealer_AfterSuccessfulSync_ApplicationShould: XCTestCase {
    
    func testUpdateDelegateWithoutDeletedDealer() {
        var response = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        let delegate = CapturingDealersIndexDelegate()
        let index = context.application.makeDealersIndex()
        index.setDelegate(delegate)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let dealerToDelete = response.dealers.changed.randomElement()
        response.dealers.changed = response.dealers.changed.filter({ $0.identifier != dealerToDelete.element.identifier })
        let expected = Set(response.dealers.changed.map({ $0.identifier }))
        response.dealers.changed.removeAll()
        response.dealers.deleted.append(dealerToDelete.element.identifier)
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let allDealers = delegate.capturedAlphabetisedDealerGroups.map({ $0.dealers }).reduce([], +)
        let actual = Set(allDealers.map({ $0.identifier.rawValue }))
        
        XCTAssertEqual(expected, actual,
                       "Should have removed dealer \(dealerToDelete.element.identifier)")
    }
    
}
