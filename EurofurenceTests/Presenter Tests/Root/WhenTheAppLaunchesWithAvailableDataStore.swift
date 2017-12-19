//
//  WhenTheAppLaunchesWithAvailableDataStore.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenTheAppLaunchesWithAvailableDataStore: XCTestCase {
    
    var delegate: CapturingRootModuleDelegate!
    
    override func setUp() {
        super.setUp()
        
        let app = CapturingEurofurenceApplication()
        delegate = CapturingRootModuleDelegate()
        _ = RootModuleBuilder().with(app).build().makeRootModule(delegate)
        app.capturedStoreStateResolutionHandler?(.available)
    }
    
    func testAndTheStoreIsAvailableTheDelegateIsNotToldToPreloadStore() {
        XCTAssertFalse(delegate.toldStoreShouldRefresh)
    }
    
    func testAndTheStoreIsAvailableTheDelegateIsNotToldToShowTutorial() {
        XCTAssertFalse(delegate.toldTutorialShouldBePresented)
    }
    
    func testAndTheStoreIsAvailableTheDelegateIsNotToldToShowPrincipleModule() {
        XCTAssertTrue(delegate.toldPrincipleModuleShouldBePresented)
    }
    
}
