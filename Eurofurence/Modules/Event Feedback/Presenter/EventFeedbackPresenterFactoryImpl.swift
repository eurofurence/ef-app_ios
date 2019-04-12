import EurofurenceModel

struct EventFeedbackPresenterFactoryImpl: EventFeedbackPresenterFactory {
    
    func makeEventFeedbackPresenter(for event: Event, scene: EventFeedbackScene) {
        _ = EventFeedbackPresenter(event: event, scene: scene)
    }
    
}
