import EurofurenceModel
import EventDetailComponent
import EventFeedbackComponent
import RouterCore
import ScheduleComponent

public struct ScheduleSubrouter: ScheduleComponentDelegate {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func scheduleComponentDidSelectEvent(identifier: EventIdentifier) {
        try? router.route(EventRouteable(identifier: identifier))
    }
    
    public func scheduleComponentDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
        try? router.route(EventFeedbackRouteable(identifier: event))
    }
    
}
