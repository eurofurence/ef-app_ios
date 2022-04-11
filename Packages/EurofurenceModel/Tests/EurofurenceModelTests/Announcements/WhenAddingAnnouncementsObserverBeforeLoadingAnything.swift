import EurofurenceModel
import XCTest

class WhenAddingAnnouncementsObserverBeforeLoadingAnything: XCTestCase {

    func testEmptyAnnouncementsAreStillPropogatedToTheObserver() {
        let context = EurofurenceSessionTestBuilder().build()
        let observer = CapturingAnnouncementsRepositoryObserver()
        context.announcementsService.add(observer)

        XCTAssertTrue(observer.didReceieveEmptyAllAnnouncements)
        XCTAssertTrue(observer.didReceieveEmptyReadAnnouncements)
    }

}
