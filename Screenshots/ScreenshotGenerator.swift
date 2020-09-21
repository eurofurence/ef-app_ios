import XCTest

class ScreenshotGenerator: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        setupSnapshot(app)
        
        enforceCorrectDeviceOrientation()
        
        app.launch()
    }
    
    private func enforceCorrectDeviceOrientation() {
        let isTablet = UIDevice.current.userInterfaceIdiom == .pad
        
        let device = XCUIDevice.shared
        if isTablet {
            device.orientation = .landscapeLeft
        } else {
            device.orientation = .portrait
        }
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
        let threeMinutes: TimeInterval = 180
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
            waitingForTabItemToAppear = !newsTabBarItem.exists
            totalWaitTimeSeconds = Date().timeIntervalSince(beganWaitingAt)
        } while waitingForTabItemToAppear && totalWaitTimeSeconds < threeMinutes
    }

    private func hideKeyboard() {
        let hideKeyboardButton = app.buttons["Hide keyboard"]
        if hideKeyboardButton.exists {
            hideKeyboardButton.tap()
        }
    }
    
    func testScreenshots() {
        navigateToRootTabController()
        
        snapshot("01_News")

        app.tabBars.buttons["Schedule"].tap()
        app.tables.firstMatch.swipeDown()
        
        snapshot("02_Schedule")
        
        let searchField = app.searchFields["Search"]
        searchField.tap()
        searchField.typeText("comic")
        app.tables["Search results"].staticTexts["ECC Room 4"].tap()
        
        if app.tables.buttons["Add to Favourites"].exists {
            app.tables.buttons["Add to Favourites"].tap()
        }
        
        snapshot("03_EventDetail")
        
        hideKeyboard()
        app.tabBars["Tab Bar"].buttons["Dealers"].tap()

        app.tabBars.buttons["Dealers"].tap()
        
        snapshot("04_Dealers")
        
        app.tables.staticTexts["Eurofurence Shop"].tap()
        
        snapshot("05_DealerDetail")
        
        app.tabBars.buttons["Information"].tap()
        
        snapshot("06_Information")
    }

}
