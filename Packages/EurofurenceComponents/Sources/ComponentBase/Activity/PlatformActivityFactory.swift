import Foundation

public struct PlatformActivityFactory: ActivityFactory {
    
    public init() {
        
    }
    
    public func makeActivity(type: String, title: String, url: URL?) -> Activity {
        let userActivity = NSUserActivity(activityType: type)
        userActivity.title = title
        userActivity.webpageURL = url
        
        return PlatformActivity(userActivity: userActivity)
    }
    
    private struct PlatformActivity: Activity {
        
        var userActivity: NSUserActivity
        
        func becomeCurrent() {
            userActivity.becomeCurrent()
        }
        
        func resignCurrent() {
            userActivity.resignCurrent()
        }
        
        func markEligibleForPublicIndexing() {
            userActivity.isEligibleForPublicIndexing = true
        }
        
        func markEligibleForLocalIndexing() {
            userActivity.isEligibleForSearch = true
        }
        
    }
    
}
