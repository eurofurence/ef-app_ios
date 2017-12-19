//
//  WhenTheAppLaunchesWithStaleDataStore.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenTheAppLaunchesWithStaleDataStore: XCTestCase {
    
    var delegate: CapturingRootModuleDelegate!
    
    override func setUp() {
        super.setUp()
        
        let app = CapturingEurofurenceApplication()
        delegate = CapturingRootModuleDelegate()
        _ = RootModuleBuilder().with(app).build().makeRootModule(delegate)
        app.capturedStoreStateResolutionHandler?(.stale)
    }
    
    func testAndTheStoreIsStaleTheDelegateIsToldToPreloadStore() {
        XCTAssertTrue(delegate.toldStoreShouldRefresh)
    }
    
    func testAndTheStoreIsStaleTheDelegateIsNotToldToShowTutorial() {
        XCTAssertFalse(delegate.toldTutorialShouldBePresented)
    }
    
    func testAndTheStoreIsStaleTheDelegateIsNotToldToShowPrincipleModule() {
        XCTAssertFalse(delegate.toldPrincipleModuleShouldBePresented)
    }
    
}
