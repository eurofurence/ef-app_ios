import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class CapturingEventFeedbackSuccessWaitingRule: EventFeedbackSuccessWaitingRule {
    
    private var handler: (() -> Void)?
    func evaluateRule(handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    func elapse() {
        handler?()
    }
    
}

class EventFeedbackPresenterTestBuilder {
    
    struct Context {
        var event: FakeEvent
        var scene: CapturingEventFeedbackScene
        var delegate: CapturingEventFeedbackComponentDelegate
        var successHaptic: CapturingSuccessHaptic
        var failureHaptic: CapturingFailureHaptic
        var successWaitingRule: CapturingEventFeedbackSuccessWaitingRule
        
        var stubbedDayOfWeekString: String
        var stubbedStartTimeString: String
        var stubbedEndTimeString: String
        
        func simulateSceneDidLoad() {
            scene.simulateSceneDidLoad()
        }
    }
    
    private var event: FakeEvent = .random
    
    @discardableResult
    func with(_ event: FakeEvent) -> EventFeedbackPresenterTestBuilder {
        self.event = event
        return self
    }
    
    func build() -> Context {
        let eventService = FakeEventsService()
        eventService.events = [event]
        
        let dayOfWeekFormatter = FakeDayOfWeekFormatter()
        let stubbedDayOfWeekString = "Day Of Week"
        dayOfWeekFormatter.stub(stubbedDayOfWeekString, for: event.startDate)
        
        let startTimeFormatter = FakeHoursDateFormatter()
        let stubbedStartTimeString = "Start Time"
        startTimeFormatter.stub(stubbedStartTimeString, for: event.startDate)
        
        let endTimeFormatter = FakeHoursDateFormatter()
        let stubbedEndTimeString = "End Time"
        endTimeFormatter.stub(stubbedEndTimeString, for: event.endDate)
        
        let successWaitingRule = CapturingEventFeedbackSuccessWaitingRule()
        
        let sceneFactory = StubEventFeedbackSceneFactory()
        let successHaptic = CapturingSuccessHaptic()
        let failureHaptic = CapturingFailureHaptic()
        let presenterFactory = EventFeedbackPresenterFactoryImpl(
            eventService: eventService,
            dayOfWeekFormatter: dayOfWeekFormatter,
            startTimeFormatter: startTimeFormatter,
            endTimeFormatter: endTimeFormatter,
            successHaptic: successHaptic,
            failureHaptic: failureHaptic,
            successWaitingRule: successWaitingRule
        )
        
        let delegate = CapturingEventFeedbackComponentDelegate()
        let moduleFactory = EventFeedbackComponentFactoryImpl(
            presenterFactory: presenterFactory,
            sceneFactory: sceneFactory
        )
        
        _ = moduleFactory.makeEventFeedbackModule(for: event.identifier, delegate: delegate)
        let scene = sceneFactory.scene
        
        return Context(
            event: event,
            scene: scene,
            delegate: delegate,
            successHaptic: successHaptic,
            failureHaptic: failureHaptic,
            successWaitingRule: successWaitingRule,
            stubbedDayOfWeekString: stubbedDayOfWeekString,
            stubbedStartTimeString: stubbedStartTimeString,
            stubbedEndTimeString: stubbedEndTimeString
        )
    }
    
}
