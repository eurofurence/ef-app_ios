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
