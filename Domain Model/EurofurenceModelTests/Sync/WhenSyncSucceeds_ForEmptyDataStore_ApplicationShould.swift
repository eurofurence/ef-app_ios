import EurofurenceModel
import XCTest

class WhenSyncSucceeds_ForEmptyDataStore_ApplicationShould: XCTestCase {

    func testSaveAllCharacteristicsIntoTheStore() {
        let context = EurofurenceSessionTestBuilder().build()
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let store = context.dataStore

        context.performSuccessfulSync(response: characteristics)

        XCTAssertTrue(characteristics.knowledgeGroups.changed.contains(elementsFrom: store.fetchKnowledgeGroups()))
        XCTAssertTrue(characteristics.knowledgeEntries.changed.contains(elementsFrom: store.fetchKnowledgeEntries()))
        XCTAssertTrue(characteristics.announcements.changed.contains(elementsFrom: store.fetchAnnouncements()))
        XCTAssertTrue(characteristics.events.changed.contains(elementsFrom: store.fetchEvents()))
        XCTAssertTrue(characteristics.rooms.changed.contains(elementsFrom: store.fetchRooms()))
        XCTAssertTrue(characteristics.tracks.changed.contains(elementsFrom: store.fetchTracks()))
        XCTAssertTrue(characteristics.dealers.changed.contains(elementsFrom: store.fetchDealers()))
        XCTAssertTrue(characteristics.maps.changed.contains(elementsFrom: store.fetchMaps()))
        XCTAssertTrue(characteristics.conferenceDays.changed.contains(elementsFrom: store.fetchConferenceDays()))
        XCTAssertTrue(characteristics.images.changed.contains(elementsFrom: store.fetchImages()))
    }

}
