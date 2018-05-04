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
    
    func testTheSceneIsReturnedFromTheModuleFactory() {
        let context = AnnouncementDetailPresenterTestBuilder().build()
        XCTAssertEqual(context.announcementDetailScene, context.sceneFactory.stubbedScene)
    }
    
    func testTheSceneIsToldToShowTheAnnouncementTitle() {
        let context = AnnouncementDetailPresenterTestBuilder().build()
        XCTAssertEqual(.announcement, context.scene.capturedTitle)
    }
    
}
