import Eurofurence
import EurofurenceModel
import XCTest

class WhenKnowledgeGroupEntriesSceneLoads: XCTestCase {

    func testTheViewModelAttributesAreBoundToTheScene() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(context.viewModel.numberOfEntries, context.sceneFactory.scene.capturedNumberOfEntriesToBind)
        XCTAssertEqual(context.viewModel.title, context.sceneFactory.scene.capturedTitle)
    }

}
