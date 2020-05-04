import EurofurenceModel

public struct LeaveFeedbackFromEventNavigator: EventDetailModuleDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func eventDetailModuleDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
        try? router.route(EventFeedbackContentRepresentation(identifier: event))
    }
    
}
