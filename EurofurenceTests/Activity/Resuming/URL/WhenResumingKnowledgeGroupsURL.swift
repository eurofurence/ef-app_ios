@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenResumingKnowledgeGroupsURL: XCTestCase {

    func testTheActivityIsResumed() {
        let contentLinksService = StubContentLinksService()
        let contentRouter = CapturingContentRouter()
        let intentResumer = ActivityResumer(contentLinksService: contentLinksService, contentRouter: contentRouter)
        let url = URL.random
        contentLinksService.stub(.knowledgeGroups, for: url)
        let activity = URLActivityDescription(url: url)
        let handled = intentResumer.resume(activity: activity)
        
        XCTAssertTrue(handled)
        XCTAssertTrue(contentRouter.didResumeViewingKnowledgeGroups)
    }

}
