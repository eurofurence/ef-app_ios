@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class EventFeedbackSceneTests: XCTestCase {

    func testModuleFactoryUsesSceneFromStoryboard() {
        let presenterFactory = DummyEventFeedbackPresenterFactory()
        let sceneFactory = StoryboardEventFeedbackSceneFactory()
        let moduleFactory = EventFeedbackModuleProvidingImpl(presenterFactory: presenterFactory, sceneFactory: sceneFactory)
        let module = moduleFactory.makeEventFeedbackModule(for: FakeEvent.random, delegate: CapturingEventFeedbackModuleDelegate()) as? EventFeedbackViewController
        
        XCTAssertNotNil(module)
        XCTAssertNotNil(module?.storyboard)
    }

}
