@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class EventDetailPresenter_InteractionRecordingTests: XCTestCase {

    func testLoadingSceneBeginsRecording() {
        let event = FakeEvent.random
        let context = EventDetailPresenterTestBuilder().build(for: event)
        
        XCTAssertNil(context.eventInteractionRecorder.witnessedEvent)
        
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.eventInteractionRecorder.witnessedEvent, event.identifier)
    }
    
    func testSceneAppearingMakesInteractionActive() {
        let event = FakeEvent.random
        let context = EventDetailPresenterTestBuilder().build(for: event)
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(.unset, context.eventInteractionRecorder.currentInteraction?.state)
        
        context.simulateSceneDidAppear()
        
        XCTAssertEqual(.active, context.eventInteractionRecorder.currentInteraction?.state)
    }
    
    func testSceneDisappearingMakesInteractionInactive() {
        let event = FakeEvent.random
        let context = EventDetailPresenterTestBuilder().build(for: event)
        context.simulateSceneDidLoad()
        context.simulateSceneDidAppear()
        
        XCTAssertEqual(.active, context.eventInteractionRecorder.currentInteraction?.state)
        
        context.simulateSceneDidDisappear()
        
        XCTAssertEqual(.inactive, context.eventInteractionRecorder.currentInteraction?.state)
    }

}
