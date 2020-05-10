@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenShowingKnowledgeEntryWithoutLinks: XCTestCase {

    func testTheSceneIsNotToldToShowLinks() {
        let interactor = StubKnowledgeDetailViewModelFactory()
        interactor.viewModel = .randomWithoutLinks
        let context = KnowledgeDetailPresenterTestBuilder().with(interactor).build()
        context.knowledgeDetailScene.simulateSceneDidLoad()

        XCTAssertNil(context.knowledgeDetailScene.linksToPresent)
    }

}
