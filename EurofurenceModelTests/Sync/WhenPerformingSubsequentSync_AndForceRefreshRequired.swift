//
//  WhenPerformingSubsequentSync_AndForceRefreshRequired.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPerformingSubsequentSync_AndForceRefreshRequired: XCTestCase {

    func testTheAPIShouldPerformFullRefresh() {
        let store = FakeDataStore()
        var context = EurofurenceSessionTestBuilder().with(store).build()
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        let forceRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: true)
        context = EurofurenceSessionTestBuilder().with(store).with(forceRefreshRequired).build()
        context.refreshService.refreshLocalStore(completionHandler: { (_) in })
        
        XCTAssertTrue(context.api.requestedFullStoreRefresh)
    }

}
