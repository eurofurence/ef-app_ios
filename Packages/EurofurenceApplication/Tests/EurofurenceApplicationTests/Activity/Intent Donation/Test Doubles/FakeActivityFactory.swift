import EurofurenceApplication
import Foundation

class FakeActivityFactory: ActivityFactory {
    
    private(set) var producedActivity: FakeActivity?
    func makeActivity(type: String, title: String, url: URL?) -> Activity {
        let activity = FakeActivity(activityType: type, title: title, url: url)
        producedActivity = activity
        
        return activity
    }
    
}

class FakeActivity: Activity {
    
    enum State {
        case unset
        case current
        case resignedCurrent
    }
    
    private(set) var state: State = .unset
    
    let activityType: String
    let title: String
    let url: URL?
    private(set) var supportsPublicIndexing = false
    private(set) var supportsLocalIndexing = false
    
    init(activityType: String, title: String, url: URL?) {
        self.activityType = activityType
        self.title = title
        self.url = url
    }
    
    func becomeCurrent() {
        state = .current
    }
    
    func resignCurrent() {
        state = .resignedCurrent
    }
    
    func markEligibleForPublicIndexing() {
        supportsPublicIndexing = true
    }
    
    func markEligibleForLocalIndexing() {
        supportsLocalIndexing = true
    }
    
}
