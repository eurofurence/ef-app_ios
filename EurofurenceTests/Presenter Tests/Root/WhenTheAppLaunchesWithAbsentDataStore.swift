//
//  WhenTheAppLaunchesWithAbsentDataStore.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenTheAppLaunchesWithAbsentDataStore: XCTestCase {
    
    var context: RootModuleTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = RootModuleTestBuilder().with(storeState: .absent).build()
    }
    
    func testTheDelegateIsToldToShowTutorial() {
        XCTAssertTrue(context.delegate.toldTutorialShouldBePresented)
    }
    
    func testTheDelegateIsNotToldToPreloadStore() {
        XCTAssertFalse(context.delegate.toldStoreShouldRefresh)
    }
    
    func testTheDelegateIsNotToldToShowPrincipleModule() {
        XCTAssertFalse(context.delegate.toldPrincipleModuleShouldBePresented)
    }
    
}
