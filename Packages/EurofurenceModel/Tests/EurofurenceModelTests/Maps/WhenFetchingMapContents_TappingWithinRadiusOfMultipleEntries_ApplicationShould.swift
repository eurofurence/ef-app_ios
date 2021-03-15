import EurofurenceModel
import XCTest

class WhenFetchingMapContents_TappingWithinRadiusOfMultipleEntries_ApplicationShould: XCTestCase {

    func testReturnTheClosestMatch() {
        let context = EurofurenceSessionTestBuilder().build()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let room = RoomCharacteristics(identifier: .random, name: .random)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = MapCharacteristics.random
        let link = MapCharacteristics.Entry.Link(type: .conferenceRoom, name: .random, target: room.identifier)
        let entry = MapCharacteristics.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
        let anotherCloseEntry = MapCharacteristics.Entry(
            identifier: .random,
            x: entry.x + 5,
            y: entry.y + 5,
            tapRadius: entry.tapRadius,
            links: .random
        )
        
        map.entries = [anotherCloseEntry, entry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        context.performSuccessfulSync(response: syncResponse)

        var content: MapContent?
        let entity = context.mapsService.fetchMap(for: MapIdentifier(map.identifier))
        entity?.fetchContentAt(x: x, y: y, completionHandler: { content = $0 })
        let expected = MapContent.room(Room(name: room.name))

        XCTAssertEqual(expected, content)
    }

}
