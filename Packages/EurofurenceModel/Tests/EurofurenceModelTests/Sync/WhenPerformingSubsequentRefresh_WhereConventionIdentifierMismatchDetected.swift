import EurofurenceModel
import XCTest

class WhenPerformingSubsequentRefresh_WhereConventionIdentifierMismatchDetected: XCTestCase {
    
    var context: EurofurenceSessionTestBuilder.Context!
    var characteristics: ModelCharacteristics!
    
    override func setUp() {
        super.setUp()
        
        context = EurofurenceSessionTestBuilder().build()
        characteristics = ModelCharacteristics.randomWithoutDeletions
        var second = ModelCharacteristics.randomWithoutDeletions
        second.conventionIdentifier = .random
        context.performSuccessfulSync(response: characteristics)
        context.performSuccessfulSync(response: second)
    }

    func testTheStoreRemainsUnchanged() {
        let store = context.dataStore
        
        XCTAssertEqual(characteristics.knowledgeGroups.changed, store.fetchKnowledgeGroups())
        XCTAssertEqual(characteristics.knowledgeEntries.changed, store.fetchKnowledgeEntries())
        XCTAssertEqual(characteristics.announcements.changed, store.fetchAnnouncements())
        XCTAssertEqual(characteristics.events.changed, store.fetchEvents())
        XCTAssertEqual(characteristics.rooms.changed, store.fetchRooms())
        XCTAssertEqual(characteristics.tracks.changed, store.fetchTracks())
        XCTAssertEqual(characteristics.conferenceDays.changed, store.fetchConferenceDays())
        XCTAssertEqual(characteristics.dealers.changed, store.fetchDealers())
        XCTAssertEqual(characteristics.maps.changed, store.fetchMaps())
        XCTAssertEqual(characteristics.images.changed, store.fetchImages())
    }
    
    func testTheLongRunningTaskIsEnded() {
        XCTAssertEqual(context.longRunningTaskManager.state, .ended)
    }
    
    func testObserversAreNotifiedTheRefreshFinished() {
        XCTAssertEqual(context.refreshObserver.state, .finishedRefreshing)
    }
    
    func testTheCIDMismatchErrorIsProvided() {
        XCTAssertEqual(context.lastRefreshError, .conventionIdentifierMismatch)
    }

}
