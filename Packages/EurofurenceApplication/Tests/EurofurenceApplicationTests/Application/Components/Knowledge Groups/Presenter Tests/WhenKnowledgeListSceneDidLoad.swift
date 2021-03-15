import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenKnowledgeListSceneDidLoad: XCTestCase {

    func testItEntersTheLoadingState() {
        let context = KnowledgeGroupsPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneDidLoad()
        
        XCTAssertTrue(context.knowledgeViewModelFactory.toldToPrepareViewModel)
        XCTAssertTrue(context.scene.didShowLoadingIndicator)
    }

}
