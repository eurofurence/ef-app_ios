import EurofurenceModel
import XCTest

class WhenLookingUpMailToLinks: XCTestCase {

    func testTheAppProvidesTheExternalURL() {
        let context = EurofurenceSessionTestBuilder().build()
        let expected = unwrap(URL(string: "mailto:someguy@somewhere.co.uk"))
        let link = Link(name: .random, type: .webExternal, contents: expected.absoluteString)
        let action = context.contentLinksService.lookupContent(for: link)

        XCTAssertEqual(.externalURL(expected), action)
    }

}
