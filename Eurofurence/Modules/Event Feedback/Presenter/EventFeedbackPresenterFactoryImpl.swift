import EurofurenceModel

struct EventFeedbackPresenterFactoryImpl: EventFeedbackPresenterFactory {
    
    private let dayOfWeekFormatter: DayOfWeekFormatter
    private let startTimeFormatter: HoursDateFormatter
    private let endTimeFormatter: HoursDateFormatter
    
    init(dayOfWeekFormatter: DayOfWeekFormatter,
         startTimeFormatter: HoursDateFormatter,
         endTimeFormatter: HoursDateFormatter) {
        self.dayOfWeekFormatter = dayOfWeekFormatter
        self.startTimeFormatter = startTimeFormatter
        self.endTimeFormatter = endTimeFormatter
    }
    
    func makeEventFeedbackPresenter(for event: Event,
                                    scene: EventFeedbackScene,
                                    delegate: EventFeedbackModuleDelegate) {
        _ = EventFeedbackPresenter(event: event,
                                   scene: scene,
                                   delegate: delegate,
                                   dayOfWeekFormatter: dayOfWeekFormatter,
                                   startTimeFormatter: startTimeFormatter,
                                   endTimeFormatter: endTimeFormatter)
    }
    
}
