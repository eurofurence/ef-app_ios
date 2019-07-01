@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenResumingViewDealerIntent: XCTestCase {

    func testTheIntentIsResumed() {
        let contentRouter = CapturingContentRouter()
        let intentResumer = ActivityResumer(contentLinksService: StubContentLinksService(), contentRouter: contentRouter)
        let dealer = FakeDealer.random
        let dealerIntentDefinition = ViewDealerIntentDefinition(identifier: dealer.identifier, dealerName: dealer.preferredName)
        let eventIntent = StubDealerIntentDefinitionProviding(dealerIntentDefinition: dealerIntentDefinition)
        let activity = IntentActivityDescription(intent: eventIntent)
        let resumed = intentResumer.resume(activity: activity)
        
        XCTAssertTrue(resumed)
        XCTAssertEqual(dealer.identifier, contentRouter.resumedDealer)
    }

}
