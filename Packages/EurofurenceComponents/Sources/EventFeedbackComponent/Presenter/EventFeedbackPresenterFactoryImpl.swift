import ComponentBase
import EurofurenceModel

public struct EventFeedbackPresenterFactoryImpl: EventFeedbackPresenterFactory {
    
    private let eventService: ScheduleRepository
    private let dayOfWeekFormatter: DayOfWeekFormatter
    private let startTimeFormatter: HoursDateFormatter
    private let endTimeFormatter: HoursDateFormatter
    private let successHaptic: SuccessHaptic
    private let failureHaptic: FailureHaptic
    private let successWaitingRule: EventFeedbackSuccessWaitingRule
    
    public init(
        eventService: ScheduleRepository,
        dayOfWeekFormatter: DayOfWeekFormatter,
        startTimeFormatter: HoursDateFormatter,
        endTimeFormatter: HoursDateFormatter,
        successHaptic: SuccessHaptic,
        failureHaptic: FailureHaptic,
        successWaitingRule: EventFeedbackSuccessWaitingRule
    ) {
        self.eventService = eventService
        self.dayOfWeekFormatter = dayOfWeekFormatter
        self.startTimeFormatter = startTimeFormatter
        self.endTimeFormatter = endTimeFormatter
        self.successHaptic = successHaptic
        self.failureHaptic = failureHaptic
        self.successWaitingRule = successWaitingRule
    }
    
    public func makeEventFeedbackPresenter(
        for event: EventIdentifier,
        scene: EventFeedbackScene,
        delegate: EventFeedbackComponentDelegate
    ) {
        guard let event = eventService.makeEventsSchedule().fetchEvent(identifier: event) else { return }
        
        _ = EventFeedbackPresenter(event: event,
                                   scene: scene,
                                   delegate: delegate,
                                   dayOfWeekFormatter: dayOfWeekFormatter,
                                   startTimeFormatter: startTimeFormatter,
                                   endTimeFormatter: endTimeFormatter,
                                   successHaptic: successHaptic,
                                   failureHaptic: failureHaptic,
                                   successWaitingRule: successWaitingRule)
    }
    
}
