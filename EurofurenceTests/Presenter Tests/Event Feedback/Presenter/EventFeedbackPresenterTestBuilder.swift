@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class EventFeedbackPresenterTestBuilder {
    
    struct Context {
        var event: FakeEvent
        var scene: CapturingEventFeedbackScene
        var delegate: CapturingEventFeedbackModuleDelegate
        var successHaptic: CapturingSuccessHaptic
        var failureHaptic: CapturingFailureHaptic
        
        var stubbedDayOfWeekString: String
        var stubbedStartTimeString: String
        var stubbedEndTimeString: String
        
        func simulateSceneDidLoad() {
            scene.simulateSceneDidLoad()
        }
    }
    
    func build() -> Context {
        let event = FakeEvent.random
        
        let dayOfWeekFormatter = FakeDayOfWeekFormatter()
        let stubbedDayOfWeekString = "Day Of Week"
        dayOfWeekFormatter.stub(stubbedDayOfWeekString, for: event.startDate)
        
        let startTimeFormatter = FakeHoursDateFormatter()
        let stubbedStartTimeString = "Start Time"
        startTimeFormatter.stub(stubbedStartTimeString, for: event.startDate)
        
        let endTimeFormatter = FakeHoursDateFormatter()
        let stubbedEndTimeString = "End Time"
        endTimeFormatter.stub(stubbedEndTimeString, for: event.endDate)
        
        let sceneFactory = StubEventFeedbackSceneFactory()
        let successHaptic = CapturingSuccessHaptic()
        let failureHaptic = CapturingFailureHaptic()
        let presenterFactory = EventFeedbackPresenterFactoryImpl(dayOfWeekFormatter: dayOfWeekFormatter,
                                                                 startTimeFormatter: startTimeFormatter,
                                                                 endTimeFormatter: endTimeFormatter,
                                                                 successHaptic: successHaptic,
                                                                 failureHaptic: failureHaptic)
        
        let delegate = CapturingEventFeedbackModuleDelegate()
        let moduleFactory = EventFeedbackModuleProvidingImpl(presenterFactory: presenterFactory, sceneFactory: sceneFactory)
        _ = moduleFactory.makeEventFeedbackModule(for: event, delegate: delegate)
        let scene = sceneFactory.scene
        
        return Context(event: event,
                       scene: scene,
                       delegate: delegate,
                       successHaptic: successHaptic,
                       failureHaptic: failureHaptic,
                       stubbedDayOfWeekString: stubbedDayOfWeekString,
                       stubbedStartTimeString: stubbedStartTimeString,
                       stubbedEndTimeString: stubbedEndTimeString)
    }
    
}
