//
//  WhenLookingUpMailToLinks.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLookingUpMailToLinks: XCTestCase {
    
    func testTheAppProvidesTheExternalURL() {
        let context = ApplicationTestBuilder().build()
        let expected = URL(string: "mailto:someguy@somewhere.co.uk")!
        let link = Link(name: .random, type: .webExternal, contents: expected.absoluteString)
        let action = context.application.lookupContent(for: link)
        
        XCTAssertEqual(.externalURL(expected), action)
    }
    
}
