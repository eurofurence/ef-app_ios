//
//  WhenTheAppLaunchesWithStaleDataStore.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenTheAppLaunchesWithStaleDataStore: XCTestCase {
    
    var context: RootModuleTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = RootModuleTestBuilder().with(storeState: .stale).build()
    }
    
    func testAndTheStoreIsStaleTheDelegateIsToldToPreloadStore() {
        XCTAssertTrue(context.delegate.toldStoreShouldRefresh)
    }
    
    func testAndTheStoreIsStaleTheDelegateIsNotToldToShowTutorial() {
        XCTAssertFalse(context.delegate.toldTutorialShouldBePresented)
    }
    
    func testAndTheStoreIsStaleTheDelegateIsNotToldToShowPrincipleModule() {
        XCTAssertFalse(context.delegate.toldPrincipleModuleShouldBePresented)
    }
    
}
