//
//  WhenBuildingEventDetailModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBuildingEventDetailModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        let context = EventDetailPresenterTestBuilder().build()
        XCTAssertTrue(context.scene === context.producedViewController)
    }

}
