//
//  WhenBuildingMapDetailModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingMapDetailModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturned() {
        let context = MapDetailPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }

}
