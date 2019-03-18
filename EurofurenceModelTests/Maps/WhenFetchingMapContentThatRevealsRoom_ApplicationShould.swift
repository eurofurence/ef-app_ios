//
//  WhenFetchingMapContentThatRevealsRoom_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingMapContentThatRevealsRoom_ApplicationShould: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var map: MapCharacteristics!
    var room: RoomCharacteristics!
    var x: Int!
    var y: Int!
    var tapRadius: Int!

    override func setUp() {
        super.setUp()

        context = EurofurenceSessionTestBuilder().build()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        room = RoomCharacteristics(identifier: .random, name: .random)
        (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        map = MapCharacteristics.random
        let link = MapCharacteristics.Entry.Link(type: .conferenceRoom, name: .random, target: room.identifier)
        let entry = MapCharacteristics.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
        let unrelatedEntry = MapCharacteristics.Entry(identifier: .random, x: .random, y: .random, tapRadius: 0, links: .random)
        map.entries = [entry, unrelatedEntry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        context.performSuccessfulSync(response: syncResponse)
    }

    private func fetchContent(atX x: Int, y: Int) -> MapContent? {
        var content: MapContent?
        let entity = context.mapsService.fetchMap(for: MapIdentifier(map.identifier))
        entity?.fetchContentAt(x: x, y: y, completionHandler: { content = $0 })
        
        return content
    }

    func testProvideTheRoomAsTheMapContent() {
        let expected = MapContent.room(Room(name: room.name))
        let content = fetchContent(atX: x, y: y)

        XCTAssertEqual(expected, content)
    }

    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceHorizontally_Positive() {
        let horizontalOffset = x + tapRadius + 1
        let expected = MapContent.none
        let content = fetchContent(atX: horizontalOffset, y: y)

        XCTAssertEqual(expected, content)
    }

    func testProvideTheRoomWhenJustInsideTheTapToleranceHorizontally_Positive() {
        let horizontalOffset = x + tapRadius - 1
        let expected = MapContent.room(Room(name: room.name))
        let content = fetchContent(atX: horizontalOffset, y: y)

        XCTAssertEqual(expected, content)
    }

    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceVertically_Positive() {
        let verticalOffset = y + tapRadius + 1
        let expected = MapContent.none
        let content = fetchContent(atX: x, y: verticalOffset)

        XCTAssertEqual(expected, content)
    }

    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceHorizontally_Negative() {
        let horizontalOffset = x - tapRadius - 1
        let expected = MapContent.none
        let content = fetchContent(atX: horizontalOffset, y: y)

        XCTAssertEqual(expected, content)
    }

    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceVertically_Negative() {
        let verticalOffset = y - tapRadius - 1
        let expected = MapContent.none
        let content = fetchContent(atX: x, y: verticalOffset)

        XCTAssertEqual(expected, content)
    }

    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceDiagonally() {
        let horizontalOffset = x + tapRadius - 1
        let verticalOffet = y + tapRadius - 1
        let expected = MapContent.none
        let content = fetchContent(atX: horizontalOffset, y: verticalOffet)

        XCTAssertEqual(expected, content)
    }

}
