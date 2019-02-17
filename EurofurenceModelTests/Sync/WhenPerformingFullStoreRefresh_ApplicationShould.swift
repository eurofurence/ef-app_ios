//
//  WhenPerformingFullStoreRefresh_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenPerformingFullStoreRefresh_ApplicationShould: XCTestCase {

    func testRequestSyncWithoutDeltas() {
        let dataStore = CapturingDataStore()
        dataStore.save(.randomWithoutDeletions)
        let context = ApplicationTestBuilder().with(dataStore).build()
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        _ = context.refreshService.performFullStoreRefresh { (_) in }

        XCTAssertNil(context.api.capturedLastSyncTime)
    }

}
