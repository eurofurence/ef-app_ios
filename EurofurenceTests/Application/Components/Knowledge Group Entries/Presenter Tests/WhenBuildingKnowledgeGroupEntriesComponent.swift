import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingKnowledgeGroupEntriesComponent: XCTestCase {

    func testTheSceneFromTheFactoryIsReturned() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        XCTAssertEqual(context.viewController, context.sceneFactory.scene)
    }

}
