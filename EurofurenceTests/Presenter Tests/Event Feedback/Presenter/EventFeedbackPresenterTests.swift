@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class EventFeedbackPresenterTests: XCTestCase {

    func testBindsEventTitle() {
        let event = FakeEvent.random
        let sceneFactory = StubEventFeedbackSceneFactory()
        let presenterFactory = EventFeedbackPresenterFactoryImpl(dayOfWeekFormatter: FakeDayOfWeekFormatter())
        let moduleFactory = EventFeedbackModuleProvidingImpl(presenterFactory: presenterFactory, sceneFactory: sceneFactory)
        _ = moduleFactory.makeEventFeedbackModule(for: event)
        let scene = sceneFactory.scene
        scene.simulateSceneDidLoad()
        
        XCTAssertEqual(event.title, scene.capturedViewModel?.eventTitle)
    }
    
    func testBindsEventTime() {
        let event = FakeEvent.random
        let dayOfWeekFormatter = FakeDayOfWeekFormatter()
        dayOfWeekFormatter.stub("Day Of Week", for: event.startDate)
        let sceneFactory = StubEventFeedbackSceneFactory()
        let presenterFactory = EventFeedbackPresenterFactoryImpl(dayOfWeekFormatter: dayOfWeekFormatter)
        let moduleFactory = EventFeedbackModuleProvidingImpl(presenterFactory: presenterFactory, sceneFactory: sceneFactory)
        _ = moduleFactory.makeEventFeedbackModule(for: event)
        let scene = sceneFactory.scene
        scene.simulateSceneDidLoad()
        
        let expected = "Day Of Week"
        
        XCTAssertEqual(expected, scene.capturedViewModel?.eventDayAndTime)
    }

}
