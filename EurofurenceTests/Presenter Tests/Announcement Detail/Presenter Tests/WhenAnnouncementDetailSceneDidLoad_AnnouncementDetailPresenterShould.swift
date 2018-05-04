//
//  WhenAnnouncementDetailSceneDidLoad_AnnouncementDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAnnouncementDetailSceneDidLoad_AnnouncementDetailPresenterShould: XCTestCase {
    
    func testApplyTheTitleOfTheAnnouncementOntoTheScene() {
        let context = AnnouncementDetailPresenterTestBuilder().build()
        context.simulateAnnouncementDetailSceneDidLoad()
        
        XCTAssertEqual(context.announcement.title, context.scene.capturedAnnouncementHeading)
    }
    
}
