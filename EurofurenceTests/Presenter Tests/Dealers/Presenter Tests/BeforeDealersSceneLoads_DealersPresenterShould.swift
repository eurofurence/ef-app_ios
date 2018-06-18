//
//  BeforeDealersSceneLoads_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class BeforeDealersSceneLoads_DealersPresenterShould: XCTestCase {
    
    func testNotBindUponTheScene() {
        let context = DealersPresenterTestBuilder().build()
        XCTAssertTrue(context.scene.capturedDealersPerSectionToBind.isEmpty)
    }
    
}
