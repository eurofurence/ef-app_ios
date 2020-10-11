import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class EventFeedbackSceneTests: XCTestCase {

    func testModuleFactoryUsesSceneFromStoryboard() {
        let presenterFactory = DummyEventFeedbackPresenterFactory()
        let sceneFactory = StoryboardEventFeedbackSceneFactory()
        let moduleFactory = EventFeedbackComponentFactoryImpl(
            presenterFactory: presenterFactory,
            sceneFactory: sceneFactory
        )
        
        let module = moduleFactory.makeEventFeedbackModule(
            for: .random,
            delegate: CapturingEventFeedbackComponentDelegate()
        ) as? EventFeedbackViewController
        
        XCTAssertNotNil(module)
        XCTAssertNotNil(module?.storyboard)
    }

}
