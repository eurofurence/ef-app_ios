//
//  WhenFetchingMapContents_ThatRevealsDealer_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingMapContents_ThatRevealsDealer_ApplicationShould: XCTestCase {

    func testProvideTheDealer() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dealer = DealerCharacteristics.random
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = MapCharacteristics.random
        let link = MapCharacteristics.Entry.Link(type: .dealerDetail, name: .random, target: dealer.identifier)
        let entry = MapCharacteristics.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
        map.entries = [entry]
        syncResponse.maps.changed = [map]
        syncResponse.dealers.changed = [dealer]
        context.performSuccessfulSync(response: syncResponse)

        var actual: Dealer?
        context.mapsService.fetchContent(for: MapIdentifier(map.identifier), atX: x, y: y) { (content) in
            if case .dealer(let dealer) = content {
                actual = dealer
            }
        }

        DealerAssertion()
            .assertDealer(actual, characterisedBy: dealer)
    }

}
