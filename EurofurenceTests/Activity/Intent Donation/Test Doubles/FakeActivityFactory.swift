@testable import Eurofurence

class FakeActivityFactory: ActivityFactory {
    
    private(set) var producedActivity: FakeActivity?
    func makeActivity(type: String, title: String) -> Activity {
        let activity = FakeActivity(activityType: type, title: title)
        producedActivity = activity
        
        return activity
    }
    
}

class FakeActivity: Activity {
    
    let activityType: String
    let title: String
    
    init(activityType: String, title: String) {
        self.activityType = activityType
        self.title = title
    }
    
}
