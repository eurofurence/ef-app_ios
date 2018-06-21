//
//  WhenBuildingDealerDetailModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBuildingDealerDetailModule: XCTestCase {
    
    func testTheSceneFromTheFactoryIsReturned() {
        let context = DealerDetailPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedModuleViewController)
    }
    
}
