@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenAnnouncementContainsImage_AnnouncementDetailPresenterShould: XCTestCase {

    func testBindTheImageOntoTheScene() {
        let context = AnnouncementDetailPresenterTestBuilder().build()
        context.simulateAnnouncementDetailSceneDidLoad()

        XCTAssertEqual(context.announcementViewModel.imagePNGData, context.scene.capturedAnnouncementImagePNGData)
    }

}
