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
        let activityFactory = FakeActivityFactory()
        let interactionRecorder = DonateIntentDealerInteractionRecorder(viewDealerIntentDonor: intentDonor, dealersService: dealersService, activityFactory: activityFactory)
        _ = interactionRecorder.makeInteraction(for: dealer.identifier)
        
        let expected = ViewDealerIntentDefinition(identifier: dealer.identifier, dealerName: dealer.preferredName)
        XCTAssertEqual(expected, intentDonor.donatedDealerIntentDefinition)
    }
    
    func testDealerActivityIsMade() {
        let dealer = FakeDealer.random
        let dealersService = FakeDealersService()
        dealersService.add(dealer)
        let intentDonor = CapturingViewDealerIntentDonor()
        let activityFactory = FakeActivityFactory()
        let interactionRecorder = DonateIntentDealerInteractionRecorder(viewDealerIntentDonor: intentDonor, dealersService: dealersService, activityFactory: activityFactory)
        _ = interactionRecorder.makeInteraction(for: dealer.identifier)
        
        let producedActivity = activityFactory.producedActivity
        
        let expectedTitleFormat = NSLocalizedString("ViewDealerFormatString", comment: "")
        let expectedTitle = String.localizedStringWithFormat(expectedTitleFormat, dealer.preferredName)
        XCTAssertEqual("org.eurofurence.activity.view-dealer", producedActivity?.activityType)
        XCTAssertEqual(expectedTitle, producedActivity?.title)
        XCTAssertEqual(dealer.shareableURL, producedActivity?.url)
    }
    
    func testTogglingInteractionActivationChangesCurrentStateOfActivity() {
        let dealer = FakeDealer.random
        let dealersService = FakeDealersService()
        dealersService.add(dealer)
        let intentDonor = CapturingViewDealerIntentDonor()
        let activityFactory = FakeActivityFactory()
        let interactionRecorder = DonateIntentDealerInteractionRecorder(viewDealerIntentDonor: intentDonor, dealersService: dealersService, activityFactory: activityFactory)
        let interaction = interactionRecorder.makeInteraction(for: dealer.identifier)
        let producedActivity = activityFactory.producedActivity
        
        XCTAssertEqual(.unset, producedActivity?.state)
        
        interaction?.activate()
        
        XCTAssertEqual(.current, producedActivity?.state)
        
        interaction?.deactivate()
        
        XCTAssertEqual(.resignedCurrent, producedActivity?.state)
    }

}
