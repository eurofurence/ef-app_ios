@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingAnnouncementDetailPresenter: XCTestCase {

    var context: AnnouncementDetailPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()
        context = AnnouncementDetailPresenterTestBuilder().build()
    }

    func testTheSceneIsReturnedFromTheModuleFactory() {
        XCTAssertEqual(context.announcementDetailScene, context.sceneFactory.stubbedScene)
    }

    func testTheSceneIsToldToShowTheAnnouncementTitle() {
        XCTAssertEqual(.announcement, context.scene.capturedTitle)
    }

    func testTheSceneIsNotToldToShowAnnouncementHeading() {
        XCTAssertNil(context.scene.capturedAnnouncementHeading)
    }

    func testTheSceneIsNotToldToShowAnnouncementContents() {
        XCTAssertNil(context.scene.capturedAnnouncementContents)
    }

}
