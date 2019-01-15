//
//  StoryboardPreloadSceneFactoryTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class StoryboardPreloadSceneFactoryTests: XCTestCase {

    func testThePreloadSceneViewControllerIsMade() {
        let factory = StoryboardPreloadSceneFactory()
        let scene = factory.makePreloadScene()

        XCTAssertNotNil(scene.storyboard)
    }

}
