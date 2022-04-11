import EurofurenceModel
import XCTest

class AnnouncementRemoveAllBeforeInsertTests: XCTestCase {

    func testShouldRemoveAllAnnouncementsWhenToldTo() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.announcements.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let observer = CapturingAnnouncementsRepositoryObserver()
        context.announcementsService.add(observer)

        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: subsequentResponse.announcements.changed)
    }

    func testShouldNotRemoveAllAnnouncementsWhenNotToldToRemoveThem() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = ModelCharacteristics.randomWithoutDeletions
        subsequentResponse.announcements.removeAllBeforeInsert = false
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let combinedResponses = originalResponse.announcements.changed + subsequentResponse.announcements.changed
        let observer = CapturingAnnouncementsRepositoryObserver()
        context.announcementsService.add(observer)

        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: combinedResponses)
    }

}
