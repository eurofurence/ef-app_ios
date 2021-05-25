import ComponentBase
import EurofurenceModel
import EventDetailComponent
import EventFeedbackComponent

public struct LeaveFeedbackFromEventNavigator: EventDetailComponentDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func eventDetailComponentDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
        try? router.route(EventFeedbackContentRepresentation(identifier: event))
    }
    
}
