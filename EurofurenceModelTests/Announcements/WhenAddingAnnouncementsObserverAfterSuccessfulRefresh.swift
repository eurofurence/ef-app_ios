import EurofurenceModel
import XCTest

class WhenAddingAnnouncementsObserverAfterSuccessfulRefresh: XCTestCase {

    func testTheObserverIsProvidedWithAllAnnouncements() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions

        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(observer)

        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: syncResponse.announcements.changed)
    }

}
