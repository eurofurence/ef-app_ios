import EurofurenceApplication
import EurofurenceModel

class DummyEventFeedbackPresenterFactory: EventFeedbackPresenterFactory {
    
    func makeEventFeedbackPresenter(for event: EventIdentifier,
                                    scene: EventFeedbackScene,
                                    delegate: EventFeedbackComponentDelegate) {
        
    }
    
}
