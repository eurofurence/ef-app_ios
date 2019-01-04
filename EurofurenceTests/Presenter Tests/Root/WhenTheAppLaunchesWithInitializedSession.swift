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

    func testTheAppShouldFollowThePrincipleModulePathway() {
        let context = RootModuleTestBuilder().with(storeState: .initialized).build()

        XCTAssertFalse(context.delegate.toldStoreShouldRefresh)
        XCTAssertFalse(context.delegate.toldTutorialShouldBePresented)
        XCTAssertTrue(context.delegate.toldPrincipleModuleShouldBePresented)
    }

}
