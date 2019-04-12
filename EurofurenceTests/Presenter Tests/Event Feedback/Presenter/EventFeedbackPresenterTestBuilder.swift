@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class EventFeedbackPresenterTestBuilder {
    
    struct Context {
        var event: Event
        var scene: CapturingEventFeedbackScene
        
        var stubbedDayOfWeekString: String
        
        func simulateSceneDidLoad() {
            scene.simulateSceneDidLoad()
        }
    }
    
    func build() -> Context {
        let event = FakeEvent.random
        let dayOfWeekFormatter = FakeDayOfWeekFormatter()
        let stubbedDayOfWeekString = "Day Of Week"
        dayOfWeekFormatter.stub("Day Of Week", for: event.startDate)
        let sceneFactory = StubEventFeedbackSceneFactory()
        let presenterFactory = EventFeedbackPresenterFactoryImpl(dayOfWeekFormatter: dayOfWeekFormatter)
        let moduleFactory = EventFeedbackModuleProvidingImpl(presenterFactory: presenterFactory, sceneFactory: sceneFactory)
        _ = moduleFactory.makeEventFeedbackModule(for: event)
        let scene = sceneFactory.scene
        
        return Context(event: event, scene: scene, stubbedDayOfWeekString: stubbedDayOfWeekString)
    }
    
}
