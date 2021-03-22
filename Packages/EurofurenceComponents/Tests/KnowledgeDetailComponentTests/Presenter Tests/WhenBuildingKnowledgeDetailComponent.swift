import EurofurenceModel
import KnowledgeDetailComponent
import XCTest

class WhenBuildingKnowledgeDetailComponent: XCTestCase {

    func testTheSceneFromTheFactoryIsReturned() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        XCTAssertEqual(context.knowledgeDetailScene, context.module)
    }

}
