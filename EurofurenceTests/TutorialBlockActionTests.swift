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

        action.run(CapturingTutorialActionDelegate())

        XCTAssertTrue(invoked)
    }
    
    func testRunningTheActionShouldTellTheDelegateTheActionDidFinish() {
        let action = TutorialBlockAction { }
        let delegate = CapturingTutorialActionDelegate()
        action.run(delegate)
        
        XCTAssertTrue(delegate.actionDidFinish)
    }
    
    func testRunningTheActionShouldNotTellTheDelegateTheActionDidFinishBeforeTheBlockReturns() {
        let delegate = CapturingTutorialActionDelegate()
        var wasNotifiedTooSoon = false
        let action = TutorialBlockAction {
            wasNotifiedTooSoon = delegate.actionDidFinish
        }
        
        action.run(delegate)
        
        XCTAssertFalse(wasNotifiedTooSoon)
    }
    
}
