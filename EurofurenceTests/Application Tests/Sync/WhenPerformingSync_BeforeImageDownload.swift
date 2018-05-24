//
//  WhenPerformingSync_BeforeImageDownload.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPerformingSync_BeforeImageDownload: XCTestCase {
    
    func testTheProgressShouldBeIndeterminate() {
        let context = ApplicationTestBuilder().build()
        let progress = context.refreshLocalStore()
        
        XCTAssertTrue(progress.isIndeterminate)
    }
    
}
