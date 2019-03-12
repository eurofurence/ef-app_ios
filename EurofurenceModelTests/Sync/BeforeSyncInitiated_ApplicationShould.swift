//
//  BeforeSyncInitiated_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class BeforeSyncInitiated_ApplicationShould: XCTestCase {

    func testNotRequestLongRunningTaskToBegin() {
        let context = EurofurenceSessionTestBuilder().build()
        XCTAssertFalse(context.longRunningTaskManager.didBeginTask)
    }

}
