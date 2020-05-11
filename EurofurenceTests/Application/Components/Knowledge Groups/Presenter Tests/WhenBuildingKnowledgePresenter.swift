import XCTest

class WhenBuildingKnowledgePresenter: XCTestCase {

    var context: KnowledgeGroupsPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()
        context = KnowledgeGroupsPresenterTestBuilder().build()
    }

    func testItRemainsInTheDefaultState() {
        XCTAssertEqual(.information, context.scene.capturedTitle)
        XCTAssertEqual(.information, context.scene.capturedShortTitle)
        XCTAssertFalse(context.knowledgeViewModelFactory.toldToPrepareViewModel)
        XCTAssertFalse(context.scene.didShowLoadingIndicator)
        XCTAssertFalse(context.scene.didHideLoadingIndicator)
    }

    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        XCTAssertTrue(context.scene === context.producedViewController)
    }

}
