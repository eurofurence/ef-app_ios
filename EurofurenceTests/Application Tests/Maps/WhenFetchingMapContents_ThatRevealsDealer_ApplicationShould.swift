//
//  WhenFetchingMapContents_ThatRevealsDealer_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingMapContents_ThatRevealsDealer_ApplicationShould: XCTestCase {
    
    func testProvideTheDealer() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = APISyncResponse.randomWithoutDeletions
        let dealer = APIDealer.random
        let expectedDealer = context.makeExpectedDealer(from: dealer)
        let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
        var map = APIMap.random
        let link = APIMap.Entry.Link(type: .dealerDetail, name: .random, target: dealer.identifier)
        let entry = APIMap.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
        map.entries = [entry]
        syncResponse.maps.changed = [map]
        syncResponse.dealers.changed = [dealer]
        context.performSuccessfulSync(response: syncResponse)
        
        var content: Map2.Content?
        context.application.fetchContent(for: Map2.Identifier(map.identifier), atX: x, y: y) { content = $0 }
        let expected = Map2.Content.dealer(expectedDealer)
        
        XCTAssertEqual(expected, content)
    }
    
}
