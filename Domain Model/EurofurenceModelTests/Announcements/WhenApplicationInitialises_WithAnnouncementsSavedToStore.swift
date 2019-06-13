import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenApplicationInitialises_WithAnnouncementsSavedToStore: XCTestCase {

    func testTheEventsAreProvidedToTheObserver() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(observer)

        let announcements = characteristics.announcements.changed
        AnnouncementAssertion().assertOrderedAnnouncements(observer.allAnnouncements,
                                                           characterisedBy: announcements)
    }

}
