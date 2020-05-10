@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRecordingDealerInteraction: XCTestCase {
    
    var dealer: FakeDealer!
    var interaction: Interaction!
    
    var donatedIntent: ViewDealerIntentDefinition?
    var producedActivity: FakeActivity?
    
    override func setUp() {
        super.setUp()
        
        dealer = FakeDealer.random
        let dealersService = FakeDealersService()
        dealersService.add(dealer)
        let intentDonor = CapturingViewDealerIntentDonor()
        let activityFactory = FakeActivityFactory()
        let interactionRecorder = DonateIntentDealerInteractionRecorder(
            viewDealerIntentDonor: intentDonor,
            dealersService: dealersService,
            activityFactory: activityFactory
        )
        
        interaction = interactionRecorder.makeInteraction(for: dealer.identifier)
        producedActivity = activityFactory.producedActivity
        donatedIntent = intentDonor.donatedDealerIntentDefinition
    }

    func testTheDealerInteractionAndActivityAreRecorded() {
        let expectedTitleFormat = NSLocalizedString("ViewDealerFormatString", comment: "")
        let expectedTitle = String.localizedStringWithFormat(expectedTitleFormat, dealer.preferredName)
        
        XCTAssertEqual(
            ViewDealerIntentDefinition(identifier: dealer.identifier, dealerName: dealer.preferredName),
            donatedIntent
        )
        
        XCTAssertEqual("org.eurofurence.activity.view-dealer", producedActivity?.activityType)
        XCTAssertEqual(expectedTitle, producedActivity?.title)
        XCTAssertEqual(dealer.shareableURL, producedActivity?.url)
        XCTAssertEqual(true, producedActivity?.supportsPublicIndexing)
        XCTAssertEqual(false, producedActivity?.supportsLocalIndexing)
    }
    
    func testTogglingInteractionActivationChangesCurrentStateOfActivity() {
        XCTAssertEqual(.unset, producedActivity?.state)
        
        interaction?.activate()
        
        XCTAssertEqual(.current, producedActivity?.state)
        
        interaction?.deactivate()
        
        XCTAssertEqual(.resignedCurrent, producedActivity?.state)
    }

}
