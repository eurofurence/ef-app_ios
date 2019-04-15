import EurofurenceModel

protocol EventFeedbackPresenterFactory {
    
    func makeEventFeedbackPresenter(for event: Event,
                                    scene: EventFeedbackScene,
                                    delegate: EventFeedbackModuleDelegate)
    
}
