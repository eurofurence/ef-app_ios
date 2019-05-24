import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFetchingMapContents_ThatRevealsRoom_ContentsSavedInDataStore_ApplicationShould: XCTestCase {

    func testProvideTheRoomAsTheMapContent() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let room = RoomCharacteristics(identifier: .random, name: .random)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = MapCharacteristics.random
        let link = MapCharacteristics.Entry.Link(type: .conferenceRoom, name: .random, target: room.identifier)
        let entry = MapCharacteristics.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
        let unrelatedEntry = MapCharacteristics.Entry(identifier: .random, x: .random, y: .random, tapRadius: 0, links: .random)
        map.entries = [entry, unrelatedEntry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        var content: MapContent?
        let entity = context.mapsService.fetchMap(for: MapIdentifier(map.identifier))
        entity?.fetchContentAt(x: x, y: y, completionHandler: { content = $0 })
        let expected = MapContent.room(Room(name: room.name))

        XCTAssertEqual(expected, content)
    }

}
