import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenOpeningAnnouncement_ApplicationShould: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var syncResponse: ModelCharacteristics!

    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
        syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
    }

    @discardableResult
    private func openAnnouncement(_ identifier: AnnouncementIdentifier) -> Announcement? {
        let announcement = context.announcementsService.fetchAnnouncement(identifier: identifier)
        return announcement
    }

    func testProvideTheAnnouncementToTheCompletionHandler() {
        let announcements = syncResponse.announcements.changed
        let announcement = announcements.randomElement().element
        let identifier = announcement.identifier
        let model = openAnnouncement(AnnouncementIdentifier(identifier))

        AnnouncementAssertion().assertAnnouncement(model, characterisedBy: announcement)
    }
    
    func testAnnouncementsNotImplicitlyMarkedAsReady() throws {
        let announcements = syncResponse.announcements.changed
        let announcement = announcements.randomElement().element
        let identifier = announcement.identifier
        let entity = try XCTUnwrap(openAnnouncement(AnnouncementIdentifier(identifier)))
        let readAnnouncementIdentifiers = context.dataStore.fetchReadAnnouncementIdentifiers() ?? []
        
        XCTAssertTrue(readAnnouncementIdentifiers.isEmpty)
        XCTAssertFalse(entity.isRead)
    }

    func testReadAnnouncementsSaveTheAnnouncementIdentifierToStore() throws {
        let announcements = syncResponse.announcements.changed
        let announcement = announcements.randomElement().element
        let identifier = announcement.identifier
        let entityIdentifier = AnnouncementIdentifier(identifier)
        let entity = try XCTUnwrap(openAnnouncement(AnnouncementIdentifier(identifier)))
        entity.markRead()
    
        XCTAssertTrue([entityIdentifier].contains(elementsFrom: context.dataStore.fetchReadAnnouncementIdentifiers()))
        XCTAssertTrue(entity.isRead)
    }

    func testSaveAllPreviouslyReadAnnouncementIdentifierAsRead() {
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        openAnnouncement(AnnouncementIdentifier(firstIdentifier))?.markRead()
        openAnnouncement(AnnouncementIdentifier(secondIdentifier))?.markRead()
        let expected = [firstIdentifier, secondIdentifier].map({ AnnouncementIdentifier($0) })

        XCTAssertTrue(expected.contains(elementsFrom: context.dataStore.fetchReadAnnouncementIdentifiers()))
    }

    func testTellServiceObserversWhenMarkingAnnouncementAsRead() {
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        let observer = CapturingAnnouncementsRepositoryObserver()
        context.announcementsService.add(observer)
        openAnnouncement(AnnouncementIdentifier(firstIdentifier))?.markRead()
        openAnnouncement(AnnouncementIdentifier(secondIdentifier))?.markRead()
        let expected = [firstIdentifier, secondIdentifier].map({ AnnouncementIdentifier($0) })

        XCTAssertTrue(observer.readAnnouncementIdentifiers.contains(elementsFrom: expected))
    }

    func testTellLaterAddedObserversAboutMarkedReadAnnouncements() {
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        openAnnouncement(AnnouncementIdentifier(firstIdentifier))?.markRead()
        openAnnouncement(AnnouncementIdentifier(secondIdentifier))?.markRead()
        let expected = [firstIdentifier, secondIdentifier].map({ AnnouncementIdentifier($0) })
        let observer = CapturingAnnouncementsRepositoryObserver()
        context.announcementsService.add(observer)

        XCTAssertTrue(observer.readAnnouncementIdentifiers.contains(elementsFrom: expected))
    }

    func testTellObserversAboutReadAnnouncementsWhenLoadingFromStore() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let announcements = syncResponse.announcements.changed
        let firstAnnouncement = announcements.randomElement().element
        let firstIdentifier = firstAnnouncement.identifier
        let secondAnnouncement = announcements.randomElement().element
        let secondIdentifier = secondAnnouncement.identifier
        let identifiers = [firstIdentifier, secondIdentifier].map({ AnnouncementIdentifier($0) })
        let dataStore = InMemoryDataStore(response: syncResponse)
        dataStore.performTransaction { (transaction) in
            transaction.saveReadAnnouncements(identifiers)
        }

        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingAnnouncementsRepositoryObserver()
        context.announcementsService.add(observer)

        XCTAssertTrue(observer.readAnnouncementIdentifiers.contains(elementsFrom: identifiers))
    }
    
    func testOpeningTheSameAnnouncementMultipleTimesDoesNotDuplicateItsReadState() throws {
        let announcements = syncResponse.announcements.changed
        let announcement = announcements.randomElement().element
        let identifier = announcement.identifier
        let entityIdentifier = AnnouncementIdentifier(identifier)
        openAnnouncement(AnnouncementIdentifier(identifier))?.markRead()
        openAnnouncement(AnnouncementIdentifier(identifier))?.markRead()
        
        let readAnnouncements = try XCTUnwrap(context.dataStore.fetchReadAnnouncementIdentifiers())
        XCTAssertEqual([entityIdentifier], readAnnouncements)
    }

}
