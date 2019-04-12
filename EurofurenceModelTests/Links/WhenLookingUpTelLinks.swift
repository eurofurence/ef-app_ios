import EurofurenceModel
import XCTest

class WhenLookingUpTelLinks: XCTestCase {

	func testTheAppProvidesTheExternalURL() {
		let context = EurofurenceSessionTestBuilder().build()
		let expected = URL(string: "tel:+1234567890")!
		let link = Link(name: .random, type: .webExternal, contents: expected.absoluteString)
		let action = context.contentLinksService.lookupContent(for: link)

		XCTAssertEqual(.externalURL(expected), action)
	}

}
