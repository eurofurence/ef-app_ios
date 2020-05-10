@testable import Eurofurence
import EurofurenceModel
import XCTest

class AnnouncementsPresenterBuildingTests: XCTestCase {

    func testNotBindOntoTheScene() {
        let context = AnnouncementsPresenterTestBuilder().build()
        XCTAssertNil(context.scene.capturedAnnouncementsToBind)
    }
    
    func testReturnTheSceneFromTheFactory() {
        let context = AnnouncementsPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }

    func testApplyTheAnnouncementsTitleToTheScene() {
        let context = AnnouncementsPresenterTestBuilder().build()
        XCTAssertEqual(.announcements, context.scene.capturedTitle)
    }

}
