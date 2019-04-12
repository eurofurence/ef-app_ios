@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingKnowledgeDetailModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturned() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        XCTAssertEqual(context.knowledgeDetailScene, context.module)
    }

}
