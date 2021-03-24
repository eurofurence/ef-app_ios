import XCTest

class WhenBuildingKnowledgePresenter: XCTestCase {

    var context: KnowledgeGroupsPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()
        context = KnowledgeGroupsPresenterTestBuilder().build()
    }

    func testItRemainsInTheDefaultState() {
        XCTAssertEqual("Information", context.scene.capturedTitle)
        XCTAssertEqual("Information", context.scene.capturedShortTitle)
        XCTAssertFalse(context.knowledgeViewModelFactory.toldToPrepareViewModel)
        XCTAssertFalse(context.scene.didShowLoadingIndicator)
        XCTAssertFalse(context.scene.didHideLoadingIndicator)
    }

    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        XCTAssertTrue(context.scene === context.producedViewController)
    }

}
