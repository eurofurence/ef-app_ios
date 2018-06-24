//
//  BeforeCollectThemAllSceneLoads_PresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class BeforeCollectThemAllSceneLoads_PresenterShould: XCTestCase {
    
    func testNotTellTheSceneToLoadTheGameRequest() {
        let context = CollectThemAllPresenterTestBuilder().build()
        XCTAssertNil(context.scene.capturedURLRequest)
    }
    
}
