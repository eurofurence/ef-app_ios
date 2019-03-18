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
        let context = EurofurenceSessionTestBuilder().build()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let room = syncResponse.rooms.changed.randomElement().element
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        let randomMap = syncResponse.maps.changed.randomElement()
        var map = randomMap.element
        let dealer = syncResponse.dealers.changed.randomElement().element
        let roomLink = MapCharacteristics.Entry.Link(type: .conferenceRoom, name: .random, target: room.identifier)
        let dealerLink = MapCharacteristics.Entry.Link(type: .dealerDetail, name: .random, target: dealer.identifier)
        let entry = MapCharacteristics.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [roomLink, dealerLink])
        map.entries = [entry]
        syncResponse.maps.changed[randomMap.index] = map
        context.performSuccessfulSync(response: syncResponse)
        var childContent: [MapContent] = []
        let entity = context.mapsService.fetchMap(for: MapIdentifier(map.identifier))
        entity?.fetchContentAt(x: x, y: y, completionHandler: { (content) in
            if case .multiple(let innerContent) = content {
                childContent = innerContent
            }
        })

        var witnessedDealerContent = false, witnessedRoomContent = false
        for content in childContent {
            switch content {
            case .dealer(let dealerEntity):
                witnessedDealerContent = true
                DealerAssertion().assertDealer(dealerEntity, characterisedBy: dealer)

            case .room(let roomEntity):
                witnessedRoomContent = true
                XCTAssertEqual(roomEntity.name, room.name)

            default:
                XCTFail("Unexpected content")
            }
        }

        XCTAssertTrue(witnessedDealerContent && witnessedRoomContent)
    }

}
