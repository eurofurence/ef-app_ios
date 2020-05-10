@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenKnowledgeGroupEntriesSceneLoads: XCTestCase {

    func testTheNumberOfEntriesFromTheViewModelAreBoundOntoTheScene() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(context.viewModel.numberOfEntries, context.sceneFactory.scene.capturedNumberOfEntriesToBind)
    }

    func testTheTitleFromTheViewModelIsBoundOntoTheScene() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(context.viewModel.title, context.sceneFactory.scene.capturedTitle)
    }

}
