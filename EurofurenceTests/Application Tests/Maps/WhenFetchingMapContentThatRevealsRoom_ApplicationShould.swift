//
//  WhenFetchingMapContentThatRevealsRoom_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingMapContentThatRevealsRoom_ApplicationShould: XCTestCase {
    
    var context: ApplicationTestBuilder.Context!
    var map: APIMap!
    var room: APIRoom!
    var x: Int!
    var y: Int!
    var tapRadius: Int!
    
    override func setUp() {
        super.setUp()
        
        context = ApplicationTestBuilder().build()
        var syncResponse = APISyncResponse.randomWithoutDeletions
        room = APIRoom(roomIdentifier: .random, name: .random)
        (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        map = APIMap.random
        let link = APIMap.Entry.Link(type: .conferenceRoom, name: .random, target: room.roomIdentifier)
        let entry = APIMap.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
        let unrelatedEntry = APIMap.Entry(identifier: .random, x: .random, y: .random, tapRadius: 0, links: .random)
        map.entries = [entry, unrelatedEntry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        context.performSuccessfulSync(response: syncResponse)
    }
    
    private func fetchContent(atX x: Int, y: Int) -> Map2.Content? {
        var content: Map2.Content?
        context.application.fetchContent(for: Map2.Identifier(map.identifier), atX: x, y: y) { content = $0 }
        return content
    }
    
    func testProvideTheRoomAsTheMapContent() {
        let expected = Map2.Content.room(Room(name: room.name))
        let content = fetchContent(atX: x, y: y)
        
        XCTAssertEqual(expected, content)
    }
    
    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceHorizontally_Positive() {
        let horizontalOffset = x + tapRadius + 1
        let expected = Map2.Content.none
        let content = fetchContent(atX: horizontalOffset, y: y)
        
        XCTAssertEqual(expected, content)
    }
    
    func testProvideTheRoomWhenJustInsideTheTapToleranceHorizontally_Positive() {
        let horizontalOffset = x + tapRadius - 1
        let expected = Map2.Content.room(Room(name: room.name))
        let content = fetchContent(atX: horizontalOffset, y: y)
        
        XCTAssertEqual(expected, content)
    }
    
    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceVertically_Positive() {
        let verticalOffset = y + tapRadius + 1
        let expected = Map2.Content.none
        let content = fetchContent(atX: x, y: verticalOffset)
        
        XCTAssertEqual(expected, content)
    }
    
    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceHorizontally_Negative() {
        let horizontalOffset = x - tapRadius - 1
        let expected = Map2.Content.none
        let content = fetchContent(atX: horizontalOffset, y: y)
        
        XCTAssertEqual(expected, content)
    }
    
    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceVertically_Negative() {
        let verticalOffset = y - tapRadius - 1
        let expected = Map2.Content.none
        let content = fetchContent(atX: x, y: verticalOffset)
        
        XCTAssertEqual(expected, content)
    }
    
    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceDiagonally() {
        let horizontalOffset = x + tapRadius - 1
        let verticalOffet = y + tapRadius - 1
        let expected = Map2.Content.none
        let content = fetchContent(atX: horizontalOffset, y: verticalOffet)
        
        XCTAssertEqual(expected, content)
    }
        
}
