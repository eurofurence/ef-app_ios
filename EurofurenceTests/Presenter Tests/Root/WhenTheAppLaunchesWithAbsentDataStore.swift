//
//  WhenTheAppLaunchesWithAbsentDataStore.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenTheAppLaunchesWithAbsentDataStore: XCTestCase {
    
    var delegate: CapturingRootModuleDelegate!
    
    override func setUp() {
        super.setUp()
        
        let app = CapturingEurofurenceApplication()
        delegate = CapturingRootModuleDelegate()
        _ = RootModuleBuilder().with(app).build().makeRootModule(delegate)
        app.capturedStoreStateResolutionHandler?(.absent)
    }
    
    func testTheDelegateIsToldToShowTutorial() {
        XCTAssertTrue(delegate.toldTutorialShouldBePresented)
    }
    
    func testTheDelegateIsNotToldToPreloadStore() {
        XCTAssertFalse(delegate.toldStoreShouldRefresh)
    }
    
    func testTheDelegateIsNotToldToShowPrincipleModule() {
        XCTAssertFalse(delegate.toldPrincipleModuleShouldBePresented)
    }
    
}
