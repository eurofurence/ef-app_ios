import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenDeletingTrack_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testTellTheStoreToDeleteTheTrack() {
        let dataStore = InMemoryDataStore()
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let trackToDelete = response.tracks.changed.remove(at: 0)
        response.tracks.deleted = [trackToDelete.identifier]
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)

        XCTAssertEqual(false, dataStore.fetchTracks()?.contains(trackToDelete))
    }

}
