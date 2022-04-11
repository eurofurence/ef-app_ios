import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class AnnouncementObservationTests: XCTestCase {
    
    private var context: EurofurenceSessionTestBuilder.Context!
    private var syncResponse: ModelCharacteristics!
    private var announcement: Announcement!

    override func setUpWithError() throws {
        try super.setUpWithError()

        context = EurofurenceSessionTestBuilder().build()
        syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        
        let announcements = syncResponse.announcements.changed
        let randomAnnouncement = announcements.randomElement().element
        let announcementIdentifier = AnnouncementIdentifier(randomAnnouncement.identifier)
        announcement = try XCTUnwrap(context.announcementsService.fetchAnnouncement(identifier: announcementIdentifier))
    }
    
    func testUnreadAnnouncementInitialObservation() {
        let observer = CapturingAnnouncementObserver()
        announcement.add(observer)
        
        XCTAssertEqual(.unread, observer.readState)
    }
    
    func testObservingAnnouncementTransitioningFromUnreadToRead() {
        let observer = CapturingAnnouncementObserver()
        announcement.add(observer)
        announcement.markRead()
        
        XCTAssertEqual(.read, observer.readState)
    }
    
    func testReadAnnouncementInitialObservation() {
        let observer = CapturingAnnouncementObserver()
        announcement.markRead()
        announcement.add(observer)
        
        XCTAssertEqual(.read, observer.readState)
    }
    
    func testDoesNotOverNotifyWhenMarkingReadAnnouncementAsRead() {
        class JournallingAnnouncementObserver: CapturingAnnouncementObserver {
            
            private(set) var enteredReadStateCount = 0
            override func announcementEnteredReadState(_ announcement: Announcement) {
                enteredReadStateCount += 1
                super.announcementEnteredReadState(announcement)
            }
            
        }
        
        let observer = JournallingAnnouncementObserver()
        announcement.markRead()
        announcement.add(observer)
        announcement.markRead()
        
        XCTAssertEqual(1, observer.enteredReadStateCount)
    }
    
    private class CapturingAnnouncementObserver: AnnouncementObserver {
        
        enum ReadState: Equatable {
            case unknown
            case unread
            case read
        }
        
        private(set) var readState: ReadState = .unknown
        
        func announcementEnteredUnreadState(_ announcement: Announcement) {
            readState = .unread
        }
        
        func announcementEnteredReadState(_ announcement: Announcement) {
            readState = .read
        }
        
    }
    
}
