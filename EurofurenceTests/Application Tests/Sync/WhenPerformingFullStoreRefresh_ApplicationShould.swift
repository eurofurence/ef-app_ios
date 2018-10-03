//
//  WhenPerformingFullStoreRefresh_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class WhenPerformingFullStoreRefresh_ApplicationShould: XCTestCase {
    
    func testRequestSyncWithoutDeltas() {
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(.randomWithoutDeletions)
        let context = ApplicationTestBuilder().with(dataStore).build()
        context.performSuccessfulSync(response: .randomWithoutDeletions)
        _ = context.application.performFullStoreRefresh { (_) in }
        
        XCTAssertNil(context.syncAPI.capturedLastSyncTime)
    }
    
}
