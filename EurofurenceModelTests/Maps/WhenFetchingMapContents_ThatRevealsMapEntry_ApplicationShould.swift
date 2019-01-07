//
//  WhenFetchingMapContents_ThatRevealsMapEntry_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Dominik Schöner on 17/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingMapContents_ThatRevealsMapEntry_ApplicationShould: XCTestCase {

	func testProvideTheDealer() {
		let context = ApplicationTestBuilder().build()
		var syncResponse = APISyncResponse.randomWithoutDeletions
		let expectedMapEntry = APIMap.Entry(identifier: .random, x: Int.random, y: Int.random, tapRadius: Int.random, links: [])
		var map = APIMap.random
		let link = APIMap.Entry.Link(type: .mapEntry, name: .random, target: expectedMapEntry.identifier)
		let (x, y, tapRadius) = (Int.random, Int.random, Int.random)
		let entry = APIMap.Entry(identifier: .random, x: x, y: y, tapRadius: tapRadius, links: [link])
		map.entries = [entry, expectedMapEntry]
		syncResponse.maps.changed = [map]
		context.performSuccessfulSync(response: syncResponse)

		var content: Map.Content?
		context.application.fetchContent(for: MapIdentifier(map.identifier), atX: x, y: y) { content = $0 }
		let expected = Map.Content.location(x: Float(expectedMapEntry.x), y: Float(expectedMapEntry.y), name: link.name)

		XCTAssertEqual(expected, content)
	}

}
