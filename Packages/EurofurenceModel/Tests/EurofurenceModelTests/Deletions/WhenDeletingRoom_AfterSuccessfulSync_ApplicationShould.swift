import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenDeletingRoom_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testTellTheStoreToDeleteTheRoom() {
        let dataStore = InMemoryDataStore()
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
