@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRecordingDealerInteraction: XCTestCase {

    func testTheDealerInteractionIsRecorded() {
        let dealer = FakeDealer.random
        let dealersService = FakeDealersService()
        dealersService.add(dealer)
        let intentDonor = CapturingViewDealerIntentDonor()
        let interactionRecorder = DonateIntentDealerInteractionRecorder(dealersService: dealersService, viewDealerIntentDonor: intentDonor)
        interactionRecorder.recordInteraction(for: dealer.identifier)
        
        let expected = ViewDealerIntentDefinition(identifier: dealer.identifier, dealerName: dealer.preferredName)
        XCTAssertEqual(expected, intentDonor.donatedDealerIntentDefinition)
    }

}
