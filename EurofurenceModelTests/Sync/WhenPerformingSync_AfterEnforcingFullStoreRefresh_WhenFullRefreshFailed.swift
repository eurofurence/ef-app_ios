//
//  WhenPerformingSync_AfterEnforcingFullStoreRefresh_WhenFullRefreshFailed.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModelTestDoubles
import XCTest

class WhenPerformingSync_AfterEnforcingFullStoreRefresh_WhenFullRefreshFailed: XCTestCase {

    func testTheAPIPerformsFullSync() {
        let store = FakeDataStore()
        var context = EurofurenceSessionTestBuilder().with(store).build()
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        let forceRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: true)
        context = EurofurenceSessionTestBuilder().with(store).with(forceRefreshRequired).build()
        context.refreshService.refreshLocalStore(completionHandler: { (_) in })
        context.api.simulateUnsuccessfulSync()
        context.refreshService.refreshLocalStore(completionHandler: { (_) in })
        
        XCTAssertTrue(context.api.requestedFullStoreRefresh)
    }

}
