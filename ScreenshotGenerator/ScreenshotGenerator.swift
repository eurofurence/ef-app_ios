//
//  ScreenshotGenerator.swift
//  ScreenshotGenerator
//
//  Created by Thomas Sherwood on 26/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import XCTest

class ScreenshotGenerator: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    private func navigateToRootTabController() {
        let newsTabBarItem = app.tabBars.buttons["News"]
        guard !newsTabBarItem.exists else {
            return
        }
        
        let skipPushRegistrationButton = app.buttons["No Thanks"]
        if skipPushRegistrationButton.exists {
            skipPushRegistrationButton.tap()
            app.buttons["Begin Download"].tap()
        }
        
        let beganWaitingAt = Date()
        var waitingForTabItemToAppear = true
        var totalWaitTimeSeconds: TimeInterval = 0
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
            waitingForTabItemToAppear = !newsTabBarItem.exists
            totalWaitTimeSeconds = Date().timeIntervalSince(beganWaitingAt)
        } while waitingForTabItemToAppear && totalWaitTimeSeconds < 30
    }
    
    private func takeNewsScreenshot() {
        app.tables
            .staticTexts["Eurofurence is approaching and only a few more days away!\n\nMost of the content we aggregate in the app is final by now - or at least close to it - and we want to focus on ironing out the small imperfections and issues that may still be around. At this point - let us thank you for all the feedback you all have provided so far. We tried to fix all the bugs you brought up, and we've collected all the feedback into a 'wishlist' with a small amount already making its way into the app this year - and the rest stored safely so we can hopefully make the app even better next year.\n\nWe'll be pushing lots of updates to the stores in the next days, and that means that the version you have on your phone at this instant is not the final one. Please treat this as a friendly reminder to keep your application version up to date and check for updates *often*. There may not be one at all times, but please take the time to check.\n\nThank you for helping us make this app (and convention) awesome! :3"]
            .swipeLeft()
        snapshot("01_News")
    }
    
    private func navigateToEventsTab() {
        app.tabBars.buttons["Events"].tap()
    }
    
    private func takeEventsScreenshot() {
        app.tables.children(matching: .cell).element(boundBy: 2).staticTexts["Fursuit Lounge"].swipeLeft()
        snapshot("02_Events")
    }
    
    private func takeEventDetailScreenshot() {
        let interestingEventCell = app.tables.cells.containing(.staticText, identifier:"Neon Dance").children(matching: .staticText).matching(identifier: "Neon Dance").element(boundBy: 0)
        interestingEventCell.tap()
        interestingEventCell.tap()
        snapshot("03_Event_Detail")
    }
    
    func navigateToMapsTab() {
        app.tabBars.buttons["Maps"].tap()
    }
    
    func takeMapsScreenshot() {
        snapshot("04_Maps")
    }
    
    func navigateToInformation() {
        if app.tabBars.buttons["Convention Info"].exists {
           app.tabBars.buttons["Convention Info"].tap()
        }
        else {
            app.tabBars.buttons["More"].tap()
            app.staticTexts["Convention Info"].tap()
        }
    }
    
    func takeMoreInformationScreenshot() {
        snapshot("05_Information")
    }
    
    func testScreenshots() {
        navigateToRootTabController()
        takeNewsScreenshot()
        navigateToEventsTab()
        takeEventsScreenshot()
        takeEventDetailScreenshot()
        navigateToMapsTab()
        navigateToInformation()
        takeMoreInformationScreenshot()
    }
    
}
