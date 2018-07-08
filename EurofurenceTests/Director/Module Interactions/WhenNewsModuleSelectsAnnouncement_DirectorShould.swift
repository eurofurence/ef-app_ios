//
//  WhenNewsModuleSelectsAnnouncement_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenNewsModuleSelectsAnnouncement_DirectorShould: XCTestCase {
    
    func testPushAnnouncementDetailModuleOntoNewsNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        let announcement = Announcement2.Identifier.random
        context.newsModule.simulateDidSelectAnnouncement(announcement)
        
        XCTAssertEqual(context.announcementDetailModule.stubInterface, newsNavigationController?.topViewController)
        XCTAssertEqual(announcement, context.announcementDetailModule.capturedModel)
    }
    
}
