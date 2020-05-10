@testable import Eurofurence
import EurofurenceModel
import XCTest

class BeforeAnnouncementsDetailSceneLoads_AnnouncementsPresenterShould: XCTestCase {

    func testNotBindOntoTheScene() {
        let context = AnnouncementsPresenterTestBuilder().build()
        XCTAssertNil(context.scene.capturedAnnouncementsToBind)
    }

}
