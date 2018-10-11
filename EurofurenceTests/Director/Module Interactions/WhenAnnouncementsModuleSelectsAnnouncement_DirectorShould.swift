//
//  WhenAnnouncementsModuleSelectsAnnouncement_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenAnnouncementsModuleSelectsAnnouncement_DirectorShould: XCTestCase {

    func testPushAnnouncementDetailModuleOntoNewsNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        let announcement = Announcement.Identifier.random
        context.newsModule.simulateAllAnnouncementsDisplayRequested()
        context.announcementsModule.simulateDidSelectAnnouncement(announcement)

        XCTAssertEqual(context.announcementDetailModule.stubInterface, newsNavigationController?.topViewController)
        XCTAssertEqual(announcement, context.announcementDetailModule.capturedModel)
    }

}
