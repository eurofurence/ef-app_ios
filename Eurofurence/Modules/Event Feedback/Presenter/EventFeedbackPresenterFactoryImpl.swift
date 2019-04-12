import EurofurenceModel

struct EventFeedbackPresenterFactoryImpl: EventFeedbackPresenterFactory {
    
    private let dayOfWeekFormatter: DayOfWeekFormatter
    
    init(dayOfWeekFormatter: DayOfWeekFormatter) {
        self.dayOfWeekFormatter = dayOfWeekFormatter
    }
    
    func makeEventFeedbackPresenter(for event: Event, scene: EventFeedbackScene) {
        _ = EventFeedbackPresenter(event: event, scene: scene, dayOfWeekFormatter: dayOfWeekFormatter)
    }
    
}
