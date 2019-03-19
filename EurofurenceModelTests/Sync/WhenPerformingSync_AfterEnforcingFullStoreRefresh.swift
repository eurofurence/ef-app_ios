//
//  WhenPerformingSync_AfterEnforcingFullStoreRefresh.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPerformingSync_AfterEnforcingFullStoreRefresh: XCTestCase {

    func testTheAPIShouldPerformDeltaUpdate() {
        let forceRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: true)
        let context = EurofurenceSessionTestBuilder().with(forceRefreshRequired).build()
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        
        XCTAssertFalse(context.api.requestedFullStoreRefresh)
    }

}
