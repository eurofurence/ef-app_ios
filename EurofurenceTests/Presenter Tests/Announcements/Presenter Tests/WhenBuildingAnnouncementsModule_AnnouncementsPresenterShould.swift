@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingAnnouncementsModule_AnnouncementsPresenterShould: XCTestCase {

    func testReturnTheSceneFromTheFactory() {
        let context = AnnouncementsPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }

    func testApplyTheAnnouncementsTitleToTheScene() {
        let context = AnnouncementsPresenterTestBuilder().build()
        XCTAssertEqual(.announcements, context.scene.capturedTitle)
    }

}
