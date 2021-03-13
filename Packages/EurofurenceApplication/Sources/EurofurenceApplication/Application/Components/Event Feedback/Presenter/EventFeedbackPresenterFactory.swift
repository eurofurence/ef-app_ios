import EurofurenceModel

public protocol EventFeedbackPresenterFactory {
    
    func makeEventFeedbackPresenter(for event: EventIdentifier,
                                    scene: EventFeedbackScene,
                                    delegate: EventFeedbackComponentDelegate)
    
}
