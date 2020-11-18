import EurofurenceApplicationSession
import EurofurenceModel
import XCTest

class EFAPIURLProvidingTests: XCTestCase {

    func testFormatsURLUsingCID() {
        let cid = ConventionIdentifier(identifier: "EF25")
        let urlProviding = EFAPIURLProviding(conventionIdentifier: cid)
        let expected = "https://app.eurofurence.org/\(cid.identifier)/api"
        let actual = urlProviding.url
        
        XCTAssertEqual(expected, actual)
    }

}
