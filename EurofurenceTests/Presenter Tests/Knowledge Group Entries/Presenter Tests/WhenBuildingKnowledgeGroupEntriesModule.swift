@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingKnowledgeGroupEntriesModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturned() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        XCTAssertEqual(context.viewController, context.sceneFactory.scene)
    }

}
