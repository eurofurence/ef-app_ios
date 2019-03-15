//
//  WhenFetchingMapContents_ThatRevealsDealer_ContentsSavedInDataStore_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFetchingMapContents_ThatRevealsDealer_ContentsSavedInDataStore_ApplicationShould: XCTestCase {

    func testProvideTheDealerIdentifer() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dealer = DealerCharacteristics.random
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = MapCharacteristics.random
        let link = MapCharacteristics.Entry.Link(type: .dealerDetail, name: .random, target: dealer.identifier)
        let entry = MapCharacteristics.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
        map.entries = [entry]
        syncResponse.maps.changed = [map]
        syncResponse.dealers.changed = [dealer]
        let dataStore = FakeDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        var content: MapContent = .none
        let entity = context.mapsService.fetchMap(for: MapIdentifier(map.identifier))
        entity?.fetchContentAt(x: x, y: y, completionHandler: { content = $0 })

        if case .dealer(let dealerEntity) = content {
            DealerAssertion().assertDealer(dealerEntity, characterisedBy: dealer)
        } else {
            XCTFail("Expected to find dealer content")
        }
    }

}
