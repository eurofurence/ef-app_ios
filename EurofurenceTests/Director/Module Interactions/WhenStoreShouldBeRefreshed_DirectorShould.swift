//
//  WhenStoreShouldBeRefreshed_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import XCTest

class WhenStoreShouldBeRefreshed_DirectorShould: XCTestCase {

    func testShowThePreloadModule() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateStoreShouldBeRefreshed()

        XCTAssertEqual([context.preloadModule.stubInterface], context.rootNavigationController.viewControllers)
    }

}
