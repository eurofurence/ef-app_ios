//
//  WhenLookingUpTelLinks.swift
//  EurofurenceTests
//
//  Created by Dominik Schöner on 10/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class WhenLookingUpTelLinks: XCTestCase {
	
	func testTheAppProvidesTheExternalURL() {
		let context = ApplicationTestBuilder().build()
		let expected = URL(string: "tel:+1234567890")!
		let link = Link(name: .random, type: .webExternal, contents: expected.absoluteString)
		let action = context.application.lookupContent(for: link)
		
		XCTAssertEqual(.externalURL(expected), action)
	}
	
}
