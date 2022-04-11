import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenApplicationInitialises_WithAnnouncementsSavedToStore: XCTestCase {

    func testTheEventsAreProvidedToTheObserver() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingAnnouncementsRepositoryObserver()
        context.announcementsService.add(observer)

        let announcements = characteristics.announcements.changed
        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: announcements)
    }

}
