//
//  WhenBuildingAnnouncementsModule_AnnouncementsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBuildingAnnouncementsModule_AnnouncementsPresenterShould: XCTestCase {
    
    func testReturnTheSceneFromTheFactory() {
        let context = AnnouncementsPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }
    
    func testApplyTheAnnouncementsTitleToTheScene() {
        let context = AnnouncementsPresenterTestBuilder().build()
        XCTAssertEqual(.announcements, context.scene.capturedTitle)
    }
    
}
