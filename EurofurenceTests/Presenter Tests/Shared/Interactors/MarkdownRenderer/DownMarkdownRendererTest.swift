//
//  DownMarkdownRendererTest.swift
//  EurofurenceTests
//
//  Created by Dominik Schöner on 11/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DownMarkdownRendererTest: XCTestCase {
	
	func testRenderedStringShouldRepresentInputStrippedOfMarkdown() {
		let downMarkdownRenderer = DefaultDownMarkdownRenderer()
		let expectedString = String.random
		let markdownString = "**" + expectedString + "**"
		let attributedString = downMarkdownRenderer.render(markdownString)
		
		XCTAssertEqual(attributedString.string, expectedString)
	}
	
}
