import EurofurenceModel
import Foundation

public struct RemotelyConfiguredUpcomingEventsConfiguration: UpcomingEventConfiguration {
    
    public init() {
        
    }
    
    public var intervalFromPresentForUpcomingEvents: TimeInterval {
        .hours(1)
    }
    
}

private extension TimeInterval {
    
    static func hours(_ hours: Double) -> TimeInterval {
        hours * 3600
    }
    
}
