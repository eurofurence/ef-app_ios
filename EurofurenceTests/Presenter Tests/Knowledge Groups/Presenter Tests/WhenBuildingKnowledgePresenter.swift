import XCTest

class WhenBuildingKnowledgePresenter: XCTestCase {

    var context: KnowledgeGroupsPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()
        context = KnowledgeGroupsPresenterTestBuilder().build()
    }

    func testItShouldNotTellInteractorToPrepareViewModel() {
        XCTAssertFalse(context.knowledgeInteractor.toldToPrepareViewModel)
    }

    func testItShouldNotTellTheSceneToShowTheLoadingIndicator() {
        XCTAssertFalse(context.scene.didShowLoadingIndicator)
    }

    func testTheLoadingIndicatorShouldNotBeHidden() {
        XCTAssertFalse(context.scene.didHideLoadingIndicator)
    }

    func testTheSceneFromTheFactoryIsReturnedFromTheModule() {
        XCTAssertTrue(context.scene === context.producedViewController)
    }

    func testTheSceneIsToldToShowTheConventionInformationTitle() {
        XCTAssertEqual(.conventionInformation, context.scene.capturedTitle)
    }

    func testTheSceneIsToldToShowTheConventionShortTitle() {
        XCTAssertEqual(.information, context.scene.capturedShortTitle)
    }

}
