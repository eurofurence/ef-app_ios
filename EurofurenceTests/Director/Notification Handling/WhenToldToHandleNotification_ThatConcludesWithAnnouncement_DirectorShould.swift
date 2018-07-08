//
//  WhenToldToHandleNotification_ThatConcludesWithAnnouncement_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//
@testable import Eurofurence
import XCTest

class WhenToldToHandleNotification_ThatConcludesWithAnnouncement_DirectorShould: XCTestCase {
    
    func testPushTheAnnouncementDetailControllerOntoTheNewsNavigationControllerAndSelectThatTab() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let payload = [String.random : String.random]
        let announcement = Announcement2.Identifier.random
        context.notificationHandling.stub(.announcement(announcement), for: payload)
        
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)!
        let newsTabIndex = context.tabModule.stubInterface.viewControllers?.index(of: newsNavigationController)
        context.director.handleRemoteNotification(payload) { (_) in }
        
        XCTAssertEqual(context.announcementDetailModule.stubInterface, newsNavigationController.topViewController)
        XCTAssertEqual(announcement, context.announcementDetailModule.capturedModel)
        XCTAssertEqual(newsTabIndex, context.tabModule.stubInterface.selectedTabIndex)
    }
    
}
