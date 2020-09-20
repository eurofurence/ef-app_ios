import XCTest

struct AutomationController {
    
    let app = XCUIApplication()
    
    func navigateToRootTabController() {
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
    
}
