import EurofurenceModel

class EventFeedbackPresenter: EventFeedbackSceneDelegate, EventFeedbackDelegate {
    
    private let event: Event
    private weak var scene: EventFeedbackScene?
    private let delegate: EventFeedbackComponentDelegate
    private let dayAndTimeFormatter: EventDayAndTimeFormatter
    private let successHaptic: SuccessHaptic
    private let failureHaptic: FailureHaptic
    private let successWaitingRule: EventFeedbackSuccessWaitingRule
    
    private let eventFeedback: EventFeedback
    
    init(event: Event,
         scene: EventFeedbackScene,
         delegate: EventFeedbackComponentDelegate,
         dayOfWeekFormatter: DayOfWeekFormatter,
         startTimeFormatter: HoursDateFormatter,
         endTimeFormatter: HoursDateFormatter,
         successHaptic: SuccessHaptic,
         failureHaptic: FailureHaptic,
         successWaitingRule: EventFeedbackSuccessWaitingRule) {
        self.event = event
        self.scene = scene
        self.delegate = delegate
        self.successHaptic = successHaptic
        self.failureHaptic = failureHaptic
        self.successWaitingRule = successWaitingRule
        
        dayAndTimeFormatter = EventDayAndTimeFormatter(dayOfWeekFormatter: dayOfWeekFormatter,
                                                       startTimeFormatter: startTimeFormatter,
                                                       endTimeFormatter: endTimeFormatter)
        
        eventFeedback = event.prepareFeedback()
        scene.setDelegate(self)
    }
    
    func eventFeedbackSceneDidLoad() {
        let viewModel = ViewModel(
            event: event,
            eventFeedback: eventFeedback,
            submitFeedback: { [weak self] in self?.submitFeedback() },
            cancelFeedback: { [weak self] in self?.cancelFeedback() },
            dayAndTimeFormatter: dayAndTimeFormatter,
            scene: scene
        )
        
        scene?.bind(viewModel)
        scene?.showFeedbackForm()
        scene?.enableDismissal()
    }
    
    func eventFeedbackSubmissionDidFinish(_ feedback: EventFeedback) {
        scene?.showFeedbackSubmissionSuccessful()
        scene?.enableDismissal()
        successHaptic.play()
        successWaitingRule.evaluateRule(handler: delegate.eventFeedbackCancelled)
    }
    
    func eventFeedbackSubmissionDidFail(_ feedback: EventFeedback) {
        scene?.showFeedbackForm()
        scene?.enableDismissal()
        scene?.showFeedbackSubmissionFailedPrompt()
        scene?.enableNavigationControls()
        failureHaptic.play()
    }
    
    private func submitFeedback() {
        eventFeedback.submit(self)
        scene?.showFeedbackSubmissionInProgress()
        scene?.disableNavigationControls()
        scene?.disableDismissal()
    }
    
    private var userHasEnteredFeedback: Bool {
        return eventFeedback.feedback.isEmpty == false
    }
    
    private func cancelFeedback() {
        if userHasEnteredFeedback {
            requestCancellationConfirmation()
        } else {
            abandonFeedbackEntry()
        }
    }
    
    private func requestCancellationConfirmation() {
        scene?.showDiscardFeedbackPrompt(discardHandler: abandonFeedbackEntry)
    }
    
    private func abandonFeedbackEntry() {
        delegate.eventFeedbackCancelled()
    }
    
    private struct EventDayAndTimeFormatter {
        
        var dayOfWeekFormatter: DayOfWeekFormatter
        var startTimeFormatter: HoursDateFormatter
        var endTimeFormatter: HoursDateFormatter
        
        func formatDayAndTime(from event: Event) -> String {
            let eventDayOfTheWeek = dayOfWeekFormatter.formatDayOfWeek(from: event.startDate)
            let eventStartTime = startTimeFormatter.hoursString(from: event.startDate)
            let eventEndTime = endTimeFormatter.hoursString(from: event.endDate)
            let eventDayAndTimeFormat = String.eventFeedbackDayAndTimeFormat
            
            return String.localizedStringWithFormat(eventDayAndTimeFormat,
                                                    eventDayOfTheWeek,
                                                    eventStartTime,
                                                    eventEndTime)
        }
        
    }
    
    private class ViewModel: EventFeedbackViewModel {
        
        private var eventFeedback: EventFeedback
        private let submit: () -> Void
        private let cancel: () -> Void
        
        var eventTitle: String
        var eventDayAndTime: String
        var eventLocation: String
        var eventHosts: String
        var defaultEventStarRating: Int = 0
        weak var scene: EventFeedbackScene?
        
        init(
            event: Event,
            eventFeedback: EventFeedback,
            submitFeedback: @escaping () -> Void,
            cancelFeedback: @escaping () -> Void,
            dayAndTimeFormatter: EventDayAndTimeFormatter,
            scene: EventFeedbackScene?
        ) {
            let hosts: String = {
                let formatString = String.eventHostedByFormat
                return String.localizedStringWithFormat(formatString, event.hosts)
            }()
            
            self.eventFeedback = eventFeedback
            self.scene = scene
            submit = submitFeedback
            cancel = cancelFeedback
            eventTitle = event.title
            eventDayAndTime = dayAndTimeFormatter.formatDayAndTime(from: event)
            eventLocation = event.room.name
            eventHosts = hosts
            defaultEventStarRating = eventFeedback.starRating
        }
        
        func feedbackChanged(_ feedback: String) {
            eventFeedback.feedback = feedback
            
            if feedback.isEmpty {
                scene?.enableDismissal()
            } else {
                scene?.disableDismissal()
            }
        }
        
        func ratingPercentageChanged(_ ratingPercentage: Float) {
            eventFeedback.starRating = Int(ratingPercentage * 10) / 2
        }
        
        func submitFeedback() {
            submit()
        }
        
        func cancelFeedback() {
            cancel()
        }
        
    }
    
}
