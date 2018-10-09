//
//  WhenBuildingNewsPresenterForUnauthenticatedUser.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 09/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBuildingNewsPresenterForUnauthenticatedUser: XCTestCase {
    
    var context: NewsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        context = NewsPresenterTestBuilder().build()
    }
    
    func testTheSceneIsReturnedFromTheModuleFactory() {
        XCTAssertEqual(context.newsScene, context.sceneFactory.stubbedScene)
    }
    
    func testTheSceneIsToldToShowTheNewsTitle() {
        XCTAssertEqual(.news, context.newsScene.capturedTitle)
    }
    
}
