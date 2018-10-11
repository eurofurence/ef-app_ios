//
//  WhenOpeningNotification_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenOpeningNotification_DirectorShould: XCTestCase {
    
    func testInvokeTheHandlerForSuccessfulSyncResponses() {
        let context = ApplicationDirectorTestBuilder().build()
        let payload = [String.random : String.random]
        context.notificationHandling.stub(.successfulSync, for: payload)
        var didInvokeHandler = false
        context.director.openNotification(payload) { didInvokeHandler = true }
        
        XCTAssertTrue(didInvokeHandler)
    }
    
    func testInvokeTheHandlerForUnsuccessfulSyncResponses() {
        let context = ApplicationDirectorTestBuilder().build()
        let payload = [String.random : String.random]
        context.notificationHandling.stub(.failedSync, for: payload)
        var didInvokeHandler = false
        context.director.openNotification(payload) { didInvokeHandler = true }
        
        XCTAssertTrue(didInvokeHandler)
    }
    
    func testInvokeTheHandlerForUnknownContent() {
        let context = ApplicationDirectorTestBuilder().build()
        let payload = [String.random : String.random]
        context.notificationHandling.stub(.unknown, for: payload)
        var didInvokeHandler = false
        context.director.openNotification(payload) { didInvokeHandler = true }
        
        XCTAssertTrue(didInvokeHandler)
    }
    
    func testInvokeTheHandlerForAnnouncementNotifications() {
        let context = ApplicationDirectorTestBuilder().build()
        let payload = [String.random : String.random]
        context.notificationHandling.stub(.announcement(.random), for: payload)
        var didInvokeHandler = false
        context.director.openNotification(payload) { didInvokeHandler = true }
        
        XCTAssertTrue(didInvokeHandler)
    }
    
    func testShowAnnouncement() {
        let context = ApplicationDirectorTestBuilder().build()
        let payload = [String.random : String.random]
        let announcement = Announcement.Identifier.random
        context.navigateToTabController()
        context.notificationHandling.stub(.announcement(announcement), for: payload)
        
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)!
        let newsTabIndex = context.tabModule.stubInterface.viewControllers?.index(of: newsNavigationController)
        context.director.openNotification(payload) { }
        
        XCTAssertEqual(context.announcementDetailModule.stubInterface, newsNavigationController.topViewController)
        XCTAssertEqual(announcement, context.announcementDetailModule.capturedModel)
        XCTAssertEqual(newsTabIndex, context.tabModule.stubInterface.selectedTabIndex)
    }
    
    func testInvokeTheHandlerForEventNotifications() {
        let context = ApplicationDirectorTestBuilder().build()
        let payload = [String.random : String.random]
        context.notificationHandling.stub(.event(.random), for: payload)
        var didInvokeHandler = false
        context.director.openNotification(payload) { didInvokeHandler = true }
        
        XCTAssertTrue(didInvokeHandler)
    }
    
    func testShowEvent() {
        let context = ApplicationDirectorTestBuilder().build()
        let payload = [String.random : String.random]
        let event = Event.Identifier.random
        context.navigateToTabController()
        context.notificationHandling.stub(.event(event), for: payload)
        
        let scheduleNavigationController = context.navigationController(for: context.scheduleModule.stubInterface)!
        let scheduleTabIndex = context.tabModule.stubInterface.viewControllers?.index(of: scheduleNavigationController)
        context.director.openNotification(payload) { }
        
        XCTAssertEqual(context.eventDetailModule.stubInterface, scheduleNavigationController.topViewController)
        XCTAssertEqual(event, context.eventDetailModule.capturedModel)
        XCTAssertEqual(scheduleTabIndex, context.tabModule.stubInterface.selectedTabIndex)
    }
    
    func testInvokeTheCompletionHandlerForInvalidatedAnnouncements() {
        let context = ApplicationDirectorTestBuilder().build()
        let payload = [String.random : String.random]
        context.notificationHandling.stub(.invalidatedAnnouncement, for: payload)
        var didInvokeHandler = false
        context.director.openNotification(payload) { didInvokeHandler = true }
        
        XCTAssertTrue(didInvokeHandler)
    }
    
    func testShowTheInvalidatedAnnouncementAlertForInvalidatedAnnouncement() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let payload = [String.random : String.random]
        context.notificationHandling.stub(.invalidatedAnnouncement, for: payload)
        context.director.openNotification(payload) { }
        let presentedAlert = context.tabModule.stubInterface.capturedPresentedViewController as? UIAlertController
        
        XCTAssertEqual(.invalidAnnouncementAlertTitle, presentedAlert?.title)
        XCTAssertEqual(.invalidAnnouncementAlertMessage, presentedAlert?.message)
    }
    
}
