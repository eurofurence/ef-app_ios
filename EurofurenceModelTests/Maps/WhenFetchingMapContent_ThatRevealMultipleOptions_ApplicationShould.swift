//
//  WhenFetchingMapContent_ThatRevealMultipleOptions_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingMapContent_ThatRevealMultipleOptions_ApplicationShould: XCTestCase {

    func testAdaptTheContentTypesIntoTheMultipleOption() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let room = syncResponse.rooms.changed.randomElement().element
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        let randomMap = syncResponse.maps.changed.randomElement()
        var map = randomMap.element
        let dealer = syncResponse.dealers.changed.randomElement().element
        let roomLink = MapCharacteristics.Entry.Link(type: .conferenceRoom, name: .random, target: room.roomIdentifier)
        let dealerLink = MapCharacteristics.Entry.Link(type: .dealerDetail, name: .random, target: dealer.identifier)
        let entry = MapCharacteristics.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [roomLink, dealerLink])
        map.entries = [entry]
        syncResponse.maps.changed[randomMap.index] = map
        context.performSuccessfulSync(response: syncResponse)
        var content: MapContent?
        context.mapsService.fetchContent(for: MapIdentifier(map.identifier), atX: x, y: y) { content = $0 }
        let expected = MapContent.multiple([.room(Room(name: room.name)), .dealer(context.makeExpectedDealer(from: dealer))])

        XCTAssertEqual(expected, content)
    }

}
