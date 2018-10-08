//
//  BeforeSyncInitiated_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class BeforeSyncInitiated_ApplicationShould: XCTestCase {
    
    func testNotRequestLongRunningTaskToBegin() {
        let context = ApplicationTestBuilder().build()
        XCTAssertFalse(context.longRunningTaskManager.didBeginTask)
    }
    
}
