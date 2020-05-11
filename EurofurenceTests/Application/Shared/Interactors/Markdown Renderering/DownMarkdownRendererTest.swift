import Eurofurence
import EurofurenceModel
import XCTest

class DownMarkdownRendererTest: XCTestCase {

	func testRenderedStringShouldRepresentInputStrippedOfMarkdown() {
		let downMarkdownRenderer = DefaultDownMarkdownRenderer()
		let expectedString = String.random
		let markdownString = "**" + expectedString + "**"
		let attributedString = downMarkdownRenderer.render(markdownString)

		XCTAssertEqual(attributedString.string, expectedString)
	}

	func testRenderedStringShouldBeTrimmedOfLeadingAndTrailingWhitespace() {
		let downMarkdownRenderer = DefaultDownMarkdownRenderer()
		let expectedString = String.random
		let markdownString = "\n " + expectedString + "\n   \t\n"
		let attributedString = downMarkdownRenderer.render(markdownString)

		XCTAssertEqual(attributedString.string, expectedString)
	}

}
