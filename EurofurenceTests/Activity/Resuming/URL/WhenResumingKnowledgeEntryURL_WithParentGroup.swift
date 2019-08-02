@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenResumingKnowledgeEntryURL_WithParentGroup: XCTestCase {

    func testTheActivityIsResumed() {
        let contentLinksService = StubContentLinksService()
        let contentRouter = CapturingContentRouter()
        let intentResumer = ActivityResumer(contentLinksService: contentLinksService, contentRouter: contentRouter)
        let knowledgeEntry = KnowledgeEntryIdentifier.random
        let knowledgeGroup = KnowledgeGroupIdentifier.random
        let url = URL.random
        contentLinksService.stub(.knowledge(knowledgeEntry, knowledgeGroup), for: url)
        let activity = URLActivityDescription(url: url)
        let handled = intentResumer.resume(activity: activity)
        
        let resumedKnowledgePairing = contentRouter.resumedKnowledgePairing
        
        XCTAssertTrue(handled)
        XCTAssertEqual(knowledgeEntry, resumedKnowledgePairing?.entry)
        XCTAssertEqual(knowledgeGroup, resumedKnowledgePairing?.group)
    }

}
