import EurofurenceModel
import XCTest

class WhenAddingAnnouncementsObserver_ThenRefreshSucceeds_ApplicationShould: XCTestCase {

    func testProvideTheObserverWithAllTheAnnouncements() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions

        let observer = CapturingAnnouncementsRepositoryObserver()
        context.announcementsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: syncResponse.announcements.changed)
    }

}
