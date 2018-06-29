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
    
    func testProvideTheRoomAsTheMapContent() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let room = APIRoom(roomIdentifier: .random, name: .random)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = APIMap.random
        let link = APIMap.Entry.Link(type: .conferenceRoom, name: .random, target: room.roomIdentifier)
        let entry = APIMap.Entry(x: x, y: y, tapRadius: tapRadius, links: [link])
        let unrelatedEntry = APIMap.Entry(x: .random, y: .random, tapRadius: 0, links: .random)
        map.entries = [entry, unrelatedEntry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        var content: Map2.Content?
        context.application.fetchContent(for: Map2.Identifier(map.identifier), atX: x, y: y) { content = $0 }
        let expected = Map2.Content.room(Room(name: room.name))
        
        XCTAssertEqual(expected, content)
    }
    
    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceHorizontally_Positive() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let room = APIRoom(roomIdentifier: .random, name: .random)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = APIMap.random
        let link = APIMap.Entry.Link(type: .conferenceRoom, name: .random, target: room.roomIdentifier)
        let entry = APIMap.Entry(x: x, y: y, tapRadius: tapRadius, links: [link])
        let unrelatedEntry = APIMap.Entry(x: .random, y: .random, tapRadius: 0, links: .random)
        map.entries = [entry, unrelatedEntry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        var content: Map2.Content?
        
        let horizontalOffset = x + tapRadius + 1
        context.application.fetchContent(for: Map2.Identifier(map.identifier), atX: horizontalOffset, y: y) { content = $0 }
        let expected = Map2.Content.none
        
        XCTAssertEqual(expected, content)
    }
    
    func testProvideTheRoomWhenJustInsideTheTapToleranceHorizontally_Positive() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let room = APIRoom(roomIdentifier: .random, name: .random)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = APIMap.random
        let link = APIMap.Entry.Link(type: .conferenceRoom, name: .random, target: room.roomIdentifier)
        let entry = APIMap.Entry(x: x, y: y, tapRadius: tapRadius, links: [link])
        let unrelatedEntry = APIMap.Entry(x: .random, y: .random, tapRadius: 0, links: .random)
        map.entries = [entry, unrelatedEntry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        var content: Map2.Content?
        
        let horizontalOffset = x + tapRadius - 1
        context.application.fetchContent(for: Map2.Identifier(map.identifier), atX: horizontalOffset, y: y) { content = $0 }
        let expected = Map2.Content.room(Room(name: room.name))
        
        XCTAssertEqual(expected, content)
    }
    
    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceVertically_Positive() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let room = APIRoom(roomIdentifier: .random, name: .random)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = APIMap.random
        let link = APIMap.Entry.Link(type: .conferenceRoom, name: .random, target: room.roomIdentifier)
        let entry = APIMap.Entry(x: x, y: y, tapRadius: tapRadius, links: [link])
        let unrelatedEntry = APIMap.Entry(x: .random, y: .random, tapRadius: 0, links: .random)
        map.entries = [entry, unrelatedEntry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        var content: Map2.Content?
        
        let verticalOffset = y + tapRadius + 1
        context.application.fetchContent(for: Map2.Identifier(map.identifier), atX: x, y: verticalOffset) { content = $0 }
        let expected = Map2.Content.none
        
        XCTAssertEqual(expected, content)
    }
    
    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceHorizontally_Negative() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let room = APIRoom(roomIdentifier: .random, name: .random)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = APIMap.random
        let link = APIMap.Entry.Link(type: .conferenceRoom, name: .random, target: room.roomIdentifier)
        let entry = APIMap.Entry(x: x, y: y, tapRadius: tapRadius, links: [link])
        let unrelatedEntry = APIMap.Entry(x: .random, y: .random, tapRadius: 0, links: .random)
        map.entries = [entry, unrelatedEntry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        var content: Map2.Content?
        
        let horizontalOffset = x - tapRadius - 1
        context.application.fetchContent(for: Map2.Identifier(map.identifier), atX: horizontalOffset, y: y) { content = $0 }
        let expected = Map2.Content.none
        
        XCTAssertEqual(expected, content)
    }
    
    func testNotProvideTheRoomWhenOutsideOfTheTapToleranceVertically_Negative() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let room = APIRoom(roomIdentifier: .random, name: .random)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = APIMap.random
        let link = APIMap.Entry.Link(type: .conferenceRoom, name: .random, target: room.roomIdentifier)
        let entry = APIMap.Entry(x: x, y: y, tapRadius: tapRadius, links: [link])
        let unrelatedEntry = APIMap.Entry(x: .random, y: .random, tapRadius: 0, links: .random)
        map.entries = [entry, unrelatedEntry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        var content: Map2.Content?
        
        let verticalOffset = y - tapRadius - 1
        context.application.fetchContent(for: Map2.Identifier(map.identifier), atX: x, y: verticalOffset) { content = $0 }
        let expected = Map2.Content.none
        
        XCTAssertEqual(expected, content)
    }
        
}
