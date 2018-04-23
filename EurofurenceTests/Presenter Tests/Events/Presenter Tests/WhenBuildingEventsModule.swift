//
//  WhenBuildingEventsModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBuildingEventsModule: XCTestCase {
    
    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        let context = EventsPresenterTestBuilder().build()
        XCTAssertTrue(context.scene === context.producedViewController)
    }
    
    func testTheSceneIsToldToShowTheEventsTitle() {
        let context = EventsPresenterTestBuilder().build()
        XCTAssertEqual(.events, context.scene.capturedTitle)
    }
    
}
