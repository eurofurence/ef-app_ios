import EurofurenceModel
import EventFeedbackComponent

class DummyEventFeedbackPresenterFactory: EventFeedbackPresenterFactory {
    
    func makeEventFeedbackPresenter(for event: EventIdentifier,
                                    scene: EventFeedbackScene,
                                    delegate: EventFeedbackComponentDelegate) {
        
    }
    
}
