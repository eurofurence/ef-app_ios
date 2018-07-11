//
//  WhenToldToHandleAnnouncementNotification_WhenAppShouldNotShowNotificationContent.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenToldToHandleAnnouncementNotification_WhenAppShouldNotShowNotificationContent: XCTestCase {
    
    func testNotShowTheAnnouncement() {
        let autoRouteToContentStateProviding = StubAutoRouteToContentStateProviding(autoRoute: false)
        let context = ApplicationDirectorTestBuilder().with(autoRouteToContentStateProviding).build()
        context.navigateToTabController()
        let payload = [String.random : String.random]
        let announcement = Announcement2.Identifier.random
        context.notificationHandling.stub(.announcement(announcement), for: payload)
        
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)!
        let newsTabIndex = context.tabModule.stubInterface.viewControllers?.index(of: newsNavigationController)
        context.director.handleRemoteNotification(payload) { (_) in }
        
        XCTAssertNotEqual(context.announcementDetailModule.stubInterface, newsNavigationController.topViewController)
        XCTAssertNotEqual(newsTabIndex, context.tabModule.stubInterface.selectedTabIndex)
    }
    
}
