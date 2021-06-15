import ComponentBase
import Foundation

public class FakeActivityFactory: ActivityFactory {
    
    public init() {
        
    }
    
    public private(set) var producedActivity: FakeActivity?
    public func makeActivity(type: String, title: String, url: URL?) -> Activity {
        let activity = FakeActivity(activityType: type, title: title, url: url)
        producedActivity = activity
        
        return activity
    }
    
}

public class FakeActivity: Activity {
    
    public enum State {
        case unset
        case current
        case resignedCurrent
    }
    
    public private(set) var state: State = .unset
    
    public let activityType: String
    public let title: String
    public let url: URL?
    public private(set) var supportsPublicIndexing = false
    public private(set) var supportsLocalIndexing = false
    
    public init(activityType: String, title: String, url: URL?) {
        self.activityType = activityType
        self.title = title
        self.url = url
    }
    
    public func becomeCurrent() {
        state = .current
    }
    
    public func resignCurrent() {
        state = .resignedCurrent
    }
    
    public func markEligibleForPublicIndexing() {
        supportsPublicIndexing = true
    }
    
    public func markEligibleForLocalIndexing() {
        supportsLocalIndexing = true
    }
    
}
