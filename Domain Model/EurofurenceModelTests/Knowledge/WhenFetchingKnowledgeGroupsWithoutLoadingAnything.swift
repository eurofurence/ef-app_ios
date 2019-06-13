import EurofurenceModel
import XCTest

class WhenFetchingKnowledgeGroupsWithoutLoadingAnything: XCTestCase {

    func testEmptyGroupsAreReturned() {
        let context = EurofurenceSessionTestBuilder().build()
        let observer = CapturingKnowledgeServiceObserver()
        context.knowledgeService.add(observer)

        XCTAssertTrue(observer.wasProvidedWithEmptyGroups)
    }

}
