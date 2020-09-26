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
    
    func testScreenshots() {
        automationController.transitionToContent()
        
        snapshot("01_News")

        automationController.tapTab(.schedule)
        
        app.tables.firstMatch.swipeDown()
        
        snapshot("02_Schedule")
        
        app.tables.staticTexts["Artists' Lounge"].tap()
        
        snapshot("03_EventDetail")
        
        automationController.tapTab(.dealers)
        
        snapshot("04_Dealers")
        
        app.tables.staticTexts["Eurofurence Shop"].tap()
        
        snapshot("05_DealerDetail")
        
        automationController.tapTab(.information)
        
        snapshot("06_Information")
    }

}
