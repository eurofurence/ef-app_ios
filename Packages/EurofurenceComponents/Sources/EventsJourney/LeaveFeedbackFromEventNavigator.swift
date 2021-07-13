import EurofurenceModel
import EventDetailComponent
import EventFeedbackComponent
import RouterCore

public struct LeaveFeedbackFromEventNavigator: EventDetailComponentDelegate {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func eventDetailComponentDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
        try? router.route(EventFeedbackRouteable(identifier: event))
    }
    
}
