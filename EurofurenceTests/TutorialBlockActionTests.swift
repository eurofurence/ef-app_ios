//
//  TutorialBlockActionTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class TutorialBlockActionTests: XCTestCase {
    
    func testRunningTheActionShouldInvokeTheBlock() {
        var invoked = false
        let action = TutorialBlockAction {
            invoked = true
        }

        action.run()

        XCTAssertTrue(invoked)
    }
    
}
