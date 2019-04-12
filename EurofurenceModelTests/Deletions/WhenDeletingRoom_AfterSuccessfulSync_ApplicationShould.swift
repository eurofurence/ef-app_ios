import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDeletingRoom_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testTellTheStoreToDeleteTheRoom() {
        let dataStore = FakeDataStore()
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let roomToDelete = response.rooms.changed.remove(at: 0)
        response.rooms.deleted = [roomToDelete.identifier]
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)

        XCTAssertEqual(false, dataStore.fetchRooms()?.contains(roomToDelete))
    }

}
