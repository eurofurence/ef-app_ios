import XCTest

class ScreenshotGenerator: XCTestCase {

    var app: XCUIApplication!
    let automationController = AutomationController()

    override func setUp() {
        super.setUp()

        app = automationController.app
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

    private func hideKeyboard() {
        let hideKeyboardButton = app.buttons["Hide keyboard"]
        if hideKeyboardButton.exists {
            hideKeyboardButton.tap()
        }
    }
    
    func testScreenshots() {
        automationController.transitionToContent()
        
        snapshot("01_News")

        automationController.tapTab(.schedule)
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
        automationController.tapTab(.dealers)
        
        snapshot("04_Dealers")
        
        app.tables.staticTexts["Eurofurence Shop"].tap()
        
        snapshot("05_DealerDetail")
        
        automationController.tapTab(.information)
        
        snapshot("06_Information")
    }

}
