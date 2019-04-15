import EurofurenceModel

struct EventFeedbackPresenterFactoryImpl: EventFeedbackPresenterFactory {
    
    private let dayOfWeekFormatter: DayOfWeekFormatter
    private let startTimeFormatter: HoursDateFormatter
    private let endTimeFormatter: HoursDateFormatter
    private let successHaptic: SuccessHaptic
    private let failureHaptic: FailureHaptic
    
    init(dayOfWeekFormatter: DayOfWeekFormatter,
         startTimeFormatter: HoursDateFormatter,
         endTimeFormatter: HoursDateFormatter,
         successHaptic: SuccessHaptic,
         failureHaptic: FailureHaptic) {
        self.dayOfWeekFormatter = dayOfWeekFormatter
        self.startTimeFormatter = startTimeFormatter
        self.endTimeFormatter = endTimeFormatter
        self.successHaptic = successHaptic
        self.failureHaptic = failureHaptic
    }
    
    func makeEventFeedbackPresenter(for event: Event,
                                    scene: EventFeedbackScene,
                                    delegate: EventFeedbackModuleDelegate) {
        _ = EventFeedbackPresenter(event: event,
                                   scene: scene,
                                   delegate: delegate,
                                   dayOfWeekFormatter: dayOfWeekFormatter,
                                   startTimeFormatter: startTimeFormatter,
                                   endTimeFormatter: endTimeFormatter,
                                   successHaptic: successHaptic,
                                   failureHaptic: failureHaptic)
    }
    
}
