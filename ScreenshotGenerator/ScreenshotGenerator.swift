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
        
        if app.alerts.element.collectionViews.buttons["Allow"].exists {
            app.tap()
        }
        
        let beginDownloadButton = app.buttons["Begin Download"]
        if beginDownloadButton.exists {
            beginDownloadButton.tap()
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
    
    func testScreenshots() {
        navigateToRootTabController()
        
        snapshot("01_News")
        
        app.tabBars.buttons["Schedule"].tap()
        
        app.navigationBars.buttons["Search"].tap()
        app.searchFields["Search"].tap()
        app.searchFields["Search"].typeText("Ap")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tables.cells.staticTexts["Designing a Mobile App for a Furry Convention"].swipeLeft()
        
        snapshot("02_ScheduleSearch")
        
        app.tables.cells.staticTexts["Designing a Mobile App for a Furry Convention"].swipeRight()
        
        repeat {
            app.tables.cells.staticTexts["Designing a Mobile App for a Furry Convention"].tap()
        } while app.navigationBars["Eurofurence.EventDetailView"].exists == false
        
        
        let favouriteButton = app.navigationBars["Eurofurence.EventDetailView"].buttons["Favourite"]
        if favouriteButton.exists {
            favouriteButton.tap()
        }
        
        snapshot("03_EventDetail")
        
        app.tabBars.buttons["Dealers"].tap()
        app.tables.cells.staticTexts["Eurofurence ConStore"].firstMatch.tap()
        
        snapshot("04_DealerDetail")
        
        app.tabBars.buttons["More"].tap()
        app.staticTexts["Information"].tap()
        
        snapshot("05_Information")
    }
    
}
