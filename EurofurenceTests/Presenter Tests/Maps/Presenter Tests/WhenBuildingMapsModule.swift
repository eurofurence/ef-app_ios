//
//  WhenBuildingMapsModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBuildingMapsModule: XCTestCase {
    
    func testTheSceneFromTheFactoryIsReturned() {
        let context = MapsPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }
    
    func testTheMapsTitleIsAppliedToTheScene() {
        let context = MapsPresenterTestBuilder().build()
        XCTAssertEqual(.maps, context.scene.capturedTitle)
    }
    
}
