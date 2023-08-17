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
        app.tables.cells.firstMatch.press(forDuration: TimeInterval(integerLiteral: 1),
                                          thenDragTo: app.tabBars.firstMatch)
        snapshot("01_News")

        automationController.tapTab(.schedule)
        try automationController.transitionToKnownEvent()
        
        snapshot("02_Schedule")
        
        try automationController.tapKnownEvent()
        
        snapshot("03_EventDetail")
        
        automationController.tapTab(.dealers)
        try automationController.transitionToKnownDealer()
        
        snapshot("04_Dealers")
        
        try automationController.tapKnownDealer()
        
        snapshot("05_DealerDetail")
        
        automationController.tapTab(.information)
        
        snapshot("06_Information")
        
        try automationController.tapKnownKnowledgeGroup()
        
        snapshot("07_SocialMedia")
        
        automationController.tapTab(.maps)
        
        snapshot("08_Maps")
    }
    
    private func takeTabletScreenshots() throws {
        app.tables.cells.firstMatch.press(forDuration: TimeInterval(integerLiteral: 1),
                                          thenDragTo: app.tabBars.firstMatch)
        snapshot("01_News")

        automationController.tapTab(.schedule)
        try automationController.tapKnownEvent()
        
        snapshot("02_Schedule")
        
        automationController.tapTab(.dealers)
        try automationController.transitionToKnownDealer()
        try automationController.tapKnownDealer()
        
        snapshot("03_Dealers")
        
        automationController.tapTab(.information)
        try automationController.tapKnownKnowledgeGroup()
        
        snapshot("04_Information")
        
        automationController.tapTab(.maps)
        try automationController.tapKnownMap()
        
        snapshot("05_Maps")
    }

}
