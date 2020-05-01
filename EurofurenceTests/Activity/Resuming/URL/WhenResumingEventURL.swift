@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenResumingEventURL: XCTestCase {

    func testTheActivityIsResumed() {
        let contentLinksService = StubContentLinksService()
        let contentRouter = CapturingLegacyContentRouter()
        let intentResumer = ActivityResumer(contentLinksService: contentLinksService, contentRouter: contentRouter)
        let url = URL.random
        let event = EventIdentifier.random
        contentLinksService.stub(.event(event), for: url)
        let activity = URLActivityDescription(url: url)
        let handled = intentResumer.resume(activity: activity)
        
        XCTAssertTrue(handled)
        XCTAssertEqual(event, contentRouter.resumedEvent)
    }

}
