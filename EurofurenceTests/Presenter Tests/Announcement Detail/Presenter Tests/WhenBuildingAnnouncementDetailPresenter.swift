//
//  WhenBuildingAnnouncementDetailPresenter.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBuildingAnnouncementDetailPresenter: XCTestCase {
    
    var context: AnnouncementDetailPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        context = AnnouncementDetailPresenterTestBuilder().build()
    }
    
    func testTheSceneIsReturnedFromTheModuleFactory() {
        XCTAssertEqual(context.announcementDetailScene, context.sceneFactory.stubbedScene)
    }
    
    func testTheSceneIsToldToShowTheAnnouncementTitle() {
        XCTAssertEqual(.announcement, context.scene.capturedTitle)
    }
    
    func testTheSceneIsNotToldToShowAnnouncementHeading() {
        XCTAssertNil(context.scene.capturedAnnouncementHeading)
    }
    
    func testTheSceneIsNotToldToShowAnnouncementContents() {
        XCTAssertNil(context.scene.capturedAnnouncementContents)
    }
    
}
