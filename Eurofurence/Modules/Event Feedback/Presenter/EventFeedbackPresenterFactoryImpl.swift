import EurofurenceModel

struct EventFeedbackPresenterFactoryImpl: EventFeedbackPresenterFactory {
    
    private let eventService: EventsService
    private let dayOfWeekFormatter: DayOfWeekFormatter
    private let startTimeFormatter: HoursDateFormatter
    private let endTimeFormatter: HoursDateFormatter
    private let successHaptic: SuccessHaptic
    private let failureHaptic: FailureHaptic
    
    init(eventService: EventsService,
         dayOfWeekFormatter: DayOfWeekFormatter,
         startTimeFormatter: HoursDateFormatter,
         endTimeFormatter: HoursDateFormatter,
         successHaptic: SuccessHaptic,
         failureHaptic: FailureHaptic) {
        self.eventService = eventService
        self.dayOfWeekFormatter = dayOfWeekFormatter
        self.startTimeFormatter = startTimeFormatter
        self.endTimeFormatter = endTimeFormatter
        self.successHaptic = successHaptic
        self.failureHaptic = failureHaptic
    }
    
    func makeEventFeedbackPresenter(for event: EventIdentifier,
                                    scene: EventFeedbackScene,
                                    delegate: EventFeedbackModuleDelegate) {
        guard let event = eventService.fetchEvent(identifier: event) else { return }
        
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
