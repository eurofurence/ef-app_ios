@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenResumingKnowledgeEntry_WithoutParentGroup: XCTestCase {

    func testTheActivityIsResumed() {
        let contentLinksService = StubContentLinksService()
        let contentRouter = CapturingContentRouter()
        let intentResumer = ActivityResumer(contentLinksService: contentLinksService, contentRouter: contentRouter)
        let knowledgeEntry = KnowledgeEntryIdentifier.random
        let url = URL.random
        contentLinksService.stub(.knowledgeEntry(knowledgeEntry), for: url)
        let activity = URLActivityDescription(url: url)
        let handled = intentResumer.resume(activity: activity)
                
        XCTAssertTrue(handled)
        XCTAssertEqual(knowledgeEntry, contentRouter.resumedKnowledgeEntry)
    }

}
