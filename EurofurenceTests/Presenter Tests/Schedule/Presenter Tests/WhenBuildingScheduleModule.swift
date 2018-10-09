//
//  WhenBuildingScheduleModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBuildingScheduleModule: XCTestCase {
    
    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        let context = SchedulePresenterTestBuilder().build()
        XCTAssertTrue(context.scene === context.producedViewController)
    }
    
    func testTheSceneIsToldToShowTheScheduleTitle() {
        let context = SchedulePresenterTestBuilder().build()
        XCTAssertEqual(.schedule, context.scene.capturedTitle)
    }
    
}
