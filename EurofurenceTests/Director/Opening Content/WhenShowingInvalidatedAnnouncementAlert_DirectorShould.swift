@testable import Eurofurence
import XCTest

class WhenShowingInvalidatedAnnouncementAlert_DirectorShould: XCTestCase {

    func testShowTheInvalidatedAnnouncementAlertForInvalidatedAnnouncement() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        context.director.showInvalidatedAnnouncementAlert()
        let presentedAlert = context.tabModule.stubInterface.capturedPresentedViewController as? UIAlertController
        
        XCTAssertEqual(.invalidAnnouncementAlertTitle, presentedAlert?.title)
        XCTAssertEqual(.invalidAnnouncementAlertMessage, presentedAlert?.message)
    }

}
