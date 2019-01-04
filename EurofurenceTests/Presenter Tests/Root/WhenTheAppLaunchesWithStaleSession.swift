//
//  WhenTheAppLaunchesWithStaleSession.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenTheAppLaunchesWithStaleSession: XCTestCase {

    func testTheAppShouldFollowTheRefreshPathway() {
        let context = RootModuleTestBuilder().with(storeState: .stale).build()

        XCTAssertTrue(context.delegate.toldStoreShouldRefresh)
        XCTAssertFalse(context.delegate.toldTutorialShouldBePresented)
        XCTAssertFalse(context.delegate.toldPrincipleModuleShouldBePresented)
    }

}
