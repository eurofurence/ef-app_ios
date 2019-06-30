@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenResumingDealerURL: XCTestCase {

    func testTheActivityIsResumed() {
        let contentLinksService = StubContentLinksService()
        let contentRouter = CapturingContentRouter()
        let intentResumer = ActivityResumer(contentLinksService: contentLinksService, contentRouter: contentRouter)
        let url = URL.random
        let dealer = DealerIdentifier.random
        contentLinksService.stub(.dealer(dealer), for: url)
        let activity = URLActivityDescription(url: url)
        let handled = intentResumer.resume(activity: activity)
        
        XCTAssertTrue(handled)
        XCTAssertEqual(dealer, contentRouter.resumedDealer)
    }

}
