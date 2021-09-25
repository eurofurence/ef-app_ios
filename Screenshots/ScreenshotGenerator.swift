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
        let device = XCUIDevice.shared
        if automationController.isTablet {
            device.orientation = .landscapeLeft
        } else {
            device.orientation = .portrait
        }
    }
    
    func testScreenshots() throws {
        automationController.transitionToContent()
        
        if automationController.isTablet {
            try takeTabletScreenshots()
        } else {
            try takePhoneScreenshots()
        }
    }
    
    private func takePhoneScreenshots() throws {
        snapshot("01_News")

        automationController.tapTab(.schedule)
        
        app.tables.firstMatch.swipeDown()
        
        snapshot("02_Schedule")
        
        try automationController.tapCellWithText("Artists' Lounge")
        
        snapshot("03_EventDetail")
        
        automationController.tapTab(.dealers)
        
        snapshot("04_Dealers")
        
        try automationController.tapCellWithText("Eurofurence Shop")
        
        snapshot("05_DealerDetail")
        
        automationController.tapTab(.information)
        
        snapshot("06_Information")
    }
    
    private func takeTabletScreenshots() throws {
        snapshot("01_News")

        automationController.tapTab(.schedule)
        
        app.tables.firstMatch.swipeDown()
        
        try automationController.tapCellWithText("Artists' Lounge")
        
        snapshot("02_Schedule")
        
        automationController.tapTab(.dealers)
        
        try automationController.tapCellWithText("Eurofurence Shop")
        
        snapshot("03_Dealers")
        
        automationController.tapTab(.information)
        
        try automationController.tapCellWithText("Guest of Honor")
        
        snapshot("04_Information")
    }

}
