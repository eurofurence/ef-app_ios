import Eurofurence
import EurofurenceModel
import XCTest

class WhenKnowledgeListSceneDidLoad: XCTestCase {

    var context: KnowledgeGroupsPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = KnowledgeGroupsPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneDidLoad()
    }

    func testWhenTheViewWillAppearTheViewModelFactoryIsToldToPrepareKnowledgeGroupsListViewModel() {
        XCTAssertTrue(context.knowledgeViewModelFactory.toldToPrepareViewModel)
    }

    func testTheSceneIsToldToShowTheLoadingIndicator() {
        XCTAssertTrue(context.scene.didShowLoadingIndicator)
    }

}
