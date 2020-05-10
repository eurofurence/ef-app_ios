@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenAnnouncementDetailSceneDidLoad_AnnouncementDetailPresenterShould: XCTestCase {

    func testApplyTheTitleOfTheAnnouncementFromTheViewModelOntoTheScene() {
        let context = AnnouncementDetailPresenterTestBuilder().build()
        context.simulateAnnouncementDetailSceneDidLoad()

        XCTAssertEqual(context.announcementViewModel.heading, context.scene.capturedAnnouncementHeading)
    }

    func testApplyTheContentsOfTheAnnouncementFromTheViewModelOntoTheScene() {
        let context = AnnouncementDetailPresenterTestBuilder().build()
        context.simulateAnnouncementDetailSceneDidLoad()

        XCTAssertEqual(context.announcementViewModel.contents, context.scene.capturedAnnouncementContents)
    }

}
