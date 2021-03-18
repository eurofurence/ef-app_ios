import DealerComponent
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class DealerDetailPresenter_InteractionRecordingTests: XCTestCase {

    func testLoadingSceneBeginsRecording() {
        let identifier: DealerIdentifier = .random
        let context = DealerDetailPresenterTestBuilder().build(for: identifier)
        
        XCTAssertNil(context.dealerInteractionRecorder.currentInteraction)
        
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.dealerInteractionRecorder.witnessedDealer, identifier)
        XCTAssertEqual(context.dealerInteractionRecorder.currentInteraction?.donated, true)
    }
    
    func testSceneAppearingMakesInteractionActive() {
        let identifier: DealerIdentifier = .random
        let context = DealerDetailPresenterTestBuilder().build(for: identifier)
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(.unset, context.dealerInteractionRecorder.currentInteraction?.state)
        
        context.simulateSceneDidAppear()
        
        XCTAssertEqual(.active, context.dealerInteractionRecorder.currentInteraction?.state)
    }
    
    func testSceneDisappearingMakesInteractionInactive() {
        let identifier: DealerIdentifier = .random
        let context = DealerDetailPresenterTestBuilder().build(for: identifier)
        context.simulateSceneDidLoad()
        context.simulateSceneDidAppear()
        
        XCTAssertEqual(.active, context.dealerInteractionRecorder.currentInteraction?.state)
        
        context.simulateSceneDidDisappear()
        
        XCTAssertEqual(.inactive, context.dealerInteractionRecorder.currentInteraction?.state)
    }

}
