@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DealerDetailPresenter_InteractionRecordingTests: XCTestCase {

    func testRecordTheUserWitnessedTheDealer() {
        let identifier: DealerIdentifier = .random
        let context = DealerDetailPresenterTestBuilder().build(for: identifier)
        
        XCTAssertNil(context.dealerInteractionRecorder.witnessedDealer)
        
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.dealerInteractionRecorder.witnessedDealer, identifier)
    }

}
