@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class EventFeedbackPresenterTestBuilder {
    
    struct Context {
        var event: FakeEvent
        var scene: CapturingEventFeedbackScene
        
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
        let presenterFactory = EventFeedbackPresenterFactoryImpl(dayOfWeekFormatter: dayOfWeekFormatter,
                                                                 startTimeFormatter: startTimeFormatter,
                                                                 endTimeFormatter: endTimeFormatter)
        let moduleFactory = EventFeedbackModuleProvidingImpl(presenterFactory: presenterFactory, sceneFactory: sceneFactory)
        _ = moduleFactory.makeEventFeedbackModule(for: event)
        let scene = sceneFactory.scene
        
        return Context(event: event,
                       scene: scene,
                       stubbedDayOfWeekString: stubbedDayOfWeekString,
                       stubbedStartTimeString: stubbedStartTimeString,
                       stubbedEndTimeString: stubbedEndTimeString)
    }
    
}
