//
//  WhenFetchingMapContents_ThatRevealsRoom_ContentsSavedInDataStore_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenFetchingMapContents_ThatRevealsRoom_ContentsSavedInDataStore_ApplicationShould: XCTestCase {
    
    func testProvideTheRoomAsTheMapContent() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let room = APIRoom(roomIdentifier: .random, name: .random)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = APIMap.random
        let link = APIMap.Entry.Link(type: .conferenceRoom, name: .random, target: room.roomIdentifier)
        let entry = APIMap.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
        let unrelatedEntry = APIMap.Entry(identifier: .random, x: .random, y: .random, tapRadius: 0, links: .random)
        map.entries = [entry, unrelatedEntry]
        syncResponse.maps.changed = [map]
        syncResponse.rooms.changed = [room]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        var content: Map.Content?
        context.application.fetchContent(for: Map.Identifier(map.identifier), atX: x, y: y) { content = $0 }
        let expected = Map.Content.room(Room(name: room.name))
        
        XCTAssertEqual(expected, content)
    }
    
}
