import XCTest

struct AutomationController {
    
    let app = XCUIApplication()
    
    var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var isTablet: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
}

// MARK: - Bootstrap

extension AutomationController {
    
    func transitionToContent() {
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
    
    func tapKnownEvent() throws {
        try tapCellWithText("Nailed It!")
    }
    
    func tapKnownDealer() throws {
        try tapCellWithText("Eurofurence Shop")
    }
    
    func tapKnownKnowledgeGroup() throws {
        try tapCellWithText("Guest of Honor")
    }
    
}

// MARK: - Selecting Tabs

extension AutomationController {
    
    enum Tab {
        
        case schedule
        case dealers
        case information
        
        fileprivate func tap(in application: XCUIApplication) {
            application.tabBars.buttons[identifier].tap()
        }
        
        private var identifier: String {
            switch self {
            case .schedule:
                return "Schedule"
            case .dealers:
                return "Dealers"
            case .information:
                return "Information"
            }
        }
        
    }
    
    func tapTab(_ tab: Tab) {
        tab.tap(in: app)
    }
    
}

// MARK: - Selecting Table Cell Content

extension AutomationController {
    
    func tapCellWithText(_ text: String) throws {
        struct TimedOutFindingText: Error {
            var text: String
        }
        
        let table = app.tables.firstMatch
        let textElement = table.staticTexts[text]
        
        let startTime = Date()
        let timeout: TimeInterval = 60
        let upperTimeLimit = startTime.addingTimeInterval(timeout)
        while textElement.isHittable == false {
            let now = Date()
            if now < upperTimeLimit {
                table.swipeUp()
            } else {
                throw TimedOutFindingText(text: text)
            }
        }
        
        textElement.tap()
    }
    
}
