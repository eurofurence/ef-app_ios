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
        // We know this event has a good amount of text for most devices for testing (bar a larger iPad).
        // This may need to change as more event info pops through for EF26.
        app.buttons["Wed 24"].tap()
        try tapCellWithText("Art Show Setup & Check-In")
    }
    
    func tapKnownDealer() throws {
        try tapCellWithText("Eurofurence Shop")
    }
    
    func tapKnownKnowledgeGroup() throws {
        try tapCellWithText("Guest of Honor")
    }
    
}

// MARK: - Finding Elements

extension AutomationController {
    
    private func wait(
        for element: XCUIElement,
        timeout: TimeInterval = 60,
        search: () -> Void = {}
    ) throws {
        struct TimedOutWaitingForElement: Error {
            var element: XCUIElement
        }
        
        let startTime = Date()
        let upperTimeLimit = startTime.addingTimeInterval(timeout)
        while !element.isHittable {
            let now = Date()
            if now < upperTimeLimit {
                search()
            } else {
                throw TimedOutWaitingForElement(element: element)
            }
        }
    }
    
}

// MARK: - Skipping

extension AutomationController {
    
    func skipIfTablet(file: StaticString = #file, line: UInt = #line) throws {
        try XCTSkipIf(isTablet, "Does not apply to iPads", file: file, line: line)
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
        struct TextNotFound: Error {
            var text: String
        }
        
        let table = app.tables.firstMatch
        let textElement = table.staticTexts[text]
        
        do {
            try wait(for: textElement) {
                table.swipeUp(velocity: verticalSwipeVelocity)
            }
        } catch {
            throw TextNotFound(text: text)
        }
        
        textElement.tap()
    }
    
    private var verticalSwipeVelocity: XCUIGestureVelocity {
        switch XCUIDevice.shared.orientation {
        case .landscapeLeft, .landscapeRight:
            return 250
            
        default:
            return 400
        }
    }
    
}

// MARK: - Authenticating

extension AutomationController {
    
    func naivgateToMessages() throws {
        switch try ensureAuthenticated() {
        case .authenticated:
            // Signing in opens Messages; do nothing
            break
            
        case .alreadyAuthenticated:
            let credentials = try TestResources.loadTestCredentials()
            try tapCellWithText("Welcome, \(credentials.username) (\(credentials.registrationNumber))")
        }
    }
    
    enum AuthenticationFlow {
        case authenticated
        case alreadyAuthenticated
    }
    
    func ensureAuthenticated() throws -> AuthenticationFlow {
        let signInPrompt = app.staticTexts["You are currently not logged in"]
        guard signInPrompt.exists else { return .alreadyAuthenticated }
        
        signInPrompt.tap()
        
        let credentials = try TestResources.loadTestCredentials()
        
        let usernameText = app.textFields["org.eurofurence.login.username"]
        try wait(for: usernameText)
        usernameText.tap()
        usernameText.typeText(credentials.username)
        
        let registrationNumberText = app.textFields["org.eurofurence.login.registration-number"]
        registrationNumberText.tap()
        registrationNumberText.typeText(credentials.registrationNumber)
        
        let passwordText = app.secureTextFields["org.eurofurence.login.password"]
        passwordText.tap()
        passwordText.typeText(credentials.password)
        
        let loginButton = app.buttons["org.eurofurence.login.confirm-button"]
        loginButton.tap()
        
        // In compact size classes: the messages screen is now visible
        // In regular size classes: the news screen and the messages screen is now visible
        
        let messagesNavigationTitle = app.navigationBars["Messages"]
        try wait(for: messagesNavigationTitle)
        
        return .authenticated
    }
    
}

// MARK: - Assertions

extension AutomationController {
    
    func assertPlaceholderVisible(file: StaticString = #file, line: UInt = #line) {
        XCTAssert(
            app.images["org.eurofurence.NoContentPlaceholder"].exists,
            "Placeholder view should be visible",
            file: file,
            line: line
        )
    }
    
}
