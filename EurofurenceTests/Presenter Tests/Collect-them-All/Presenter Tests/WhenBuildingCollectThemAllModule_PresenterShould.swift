//
//  WhenBuildingCollectThemAllModule_PresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBuildingCollectThemAllModule_PresenterShould: XCTestCase {
    
    func testReturnInterfaceFromSceneFactory() {
        let context = CollectThemAllPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }
    
    func testApplyTheShortTitleToTheScene() {
        let context = CollectThemAllPresenterTestBuilder().build()
        XCTAssertEqual(.collect, context.scene.capturedShortTitle)
    }
    
}
