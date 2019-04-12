@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class EventFeedbackPresenterTests: XCTestCase {

    func testBindsEventAttributes() {
        let event = FakeEvent.random
        let sceneFactory = StubEventFeedbackSceneFactory()
        let presenterFactory = EventFeedbackPresenterFactoryImpl()
        let moduleFactory = EventFeedbackModuleProvidingImpl(presenterFactory: presenterFactory, sceneFactory: sceneFactory)
        _ = moduleFactory.makeEventFeedbackModule(for: event)
        let scene = sceneFactory.scene
        scene.simulateSceneDidLoad()
        
        XCTAssertEqual(event.title, scene.capturedViewModel?.eventTitle)
    }

}
