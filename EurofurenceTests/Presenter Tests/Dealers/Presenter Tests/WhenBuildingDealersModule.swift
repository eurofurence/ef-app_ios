//
//  WhenBuildingDealersModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBuildingDealersModule: XCTestCase {
    
    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        let context = DealersPresenterTestBuilder().build()
        XCTAssertTrue(context.scene === context.producedViewController)
    }
    
}
