//
//  WhenLookingUpWebLinks.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenLookingUpWebLinks: XCTestCase {

    func testTheAppProvidesTheURL() {
        let context = EurofurenceSessionTestBuilder().build()
        let expected = URL.random
        let link = Link(name: .random, type: .webExternal, contents: expected.absoluteString)
        let action = context.contentLinksService.lookupContent(for: link)

        XCTAssertEqual(.web(expected), action)
    }

}
