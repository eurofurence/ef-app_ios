import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRecordingDealerInteraction: XCTestCase {
    
    var dealer: FakeDealer!
    var interaction: Interaction!
    
    var intentDonor: CapturingViewDealerIntentDonor!
    var producedActivity: FakeActivity?
    
    override func setUp() {
        super.setUp()
        
        dealer = FakeDealer.random
        let dealersService = FakeDealersService()
        dealersService.add(dealer)
        intentDonor = CapturingViewDealerIntentDonor()
        let activityFactory = FakeActivityFactory()
        let interactionRecorder = DonateIntentDealerInteractionRecorder(
            viewDealerIntentDonor: intentDonor,
            dealersService: dealersService,
            activityFactory: activityFactory
        )
        
        interaction = interactionRecorder.makeInteraction(for: dealer.identifier)
        producedActivity = activityFactory.producedActivity
    }

    func testTheDealerInteractionAndActivityAreRecorded() {
        let expectedTitleFormat = NSLocalizedString("ViewDealerFormatString", comment: "")
        let expectedTitle = String.localizedStringWithFormat(expectedTitleFormat, dealer.preferredName)
        
        XCTAssertEqual("org.eurofurence.activity.view-dealer", producedActivity?.activityType)
        XCTAssertEqual(expectedTitle, producedActivity?.title)
        XCTAssertEqual(dealer.shareableURL, producedActivity?.url)
        XCTAssertEqual(true, producedActivity?.supportsPublicIndexing)
        XCTAssertEqual(false, producedActivity?.supportsLocalIndexing)
    }
    
    func testDonatingInteraction() {
        XCTAssertNil(intentDonor.donatedDealerIntentDefinition)
        
        interaction.donate()
        
        XCTAssertEqual(
            ViewDealerIntentDefinition(identifier: dealer.identifier, dealerName: dealer.preferredName),
            intentDonor.donatedDealerIntentDefinition
        )
    }
    
    func testTogglingInteractionActivationChangesCurrentStateOfActivity() {
        XCTAssertEqual(.unset, producedActivity?.state)
        
        interaction?.activate()
        
        XCTAssertEqual(.current, producedActivity?.state)
        
        interaction?.deactivate()
        
        XCTAssertEqual(.resignedCurrent, producedActivity?.state)
    }

}
