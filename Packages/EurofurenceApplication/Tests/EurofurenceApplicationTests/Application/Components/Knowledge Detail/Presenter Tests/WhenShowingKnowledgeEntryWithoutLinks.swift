import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenShowingKnowledgeEntryWithoutLinks: XCTestCase {

    func testTheSceneIsNotToldToShowLinks() {
        let viewModelFactory = StubKnowledgeDetailViewModelFactory()
        viewModelFactory.viewModel = .randomWithoutLinks
        let context = KnowledgeDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.knowledgeDetailScene.simulateSceneDidLoad()

        XCTAssertNil(context.knowledgeDetailScene.linksToPresent)
    }

}
