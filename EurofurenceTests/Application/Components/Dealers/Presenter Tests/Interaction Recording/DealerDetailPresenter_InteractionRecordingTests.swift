@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DealerDetailPresenter_InteractionRecordingTests: XCTestCase {

    func testLoadingSceneBeginsRecording() {
        let identifier: DealerIdentifier = .random
        let context = DealerDetailPresenterTestBuilder().build(for: identifier)
        
        XCTAssertNil(context.dealerInteractionRecorder.witnessedDealer)
        
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.dealerInteractionRecorder.witnessedDealer, identifier)
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
