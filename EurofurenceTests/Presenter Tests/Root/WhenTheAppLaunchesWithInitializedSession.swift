//
//  WhenTheAppLaunchesWithInitializedSession.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenTheAppLaunchesWithInitializedSession: XCTestCase {

    var context: RootModuleTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = RootModuleTestBuilder().with(storeState: .initialized).build()
    }

    func testAndTheStoreIsAvailableTheDelegateIsNotToldToPreloadStore() {
        XCTAssertFalse(context.delegate.toldStoreShouldRefresh)
    }

    func testAndTheStoreIsAvailableTheDelegateIsNotToldToShowTutorial() {
        XCTAssertFalse(context.delegate.toldTutorialShouldBePresented)
    }

    func testAndTheStoreIsAvailableTheDelegateIsNotToldToShowPrincipleModule() {
        XCTAssertTrue(context.delegate.toldPrincipleModuleShouldBePresented)
    }

}
