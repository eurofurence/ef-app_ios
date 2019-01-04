//
//  WhenTheAppLaunchesWithUninitializedSession.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenTheAppLaunchesWithUninitializedSession: XCTestCase {

    func testTheAppShouldFollowTheTutorialPathway() {
        let context = RootModuleTestBuilder().with(storeState: .uninitialized).build()

        XCTAssertTrue(context.delegate.toldTutorialShouldBePresented)
        XCTAssertFalse(context.delegate.toldStoreShouldRefresh)
        XCTAssertFalse(context.delegate.toldPrincipleModuleShouldBePresented)
    }

}
