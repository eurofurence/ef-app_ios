import EurofurenceModel
import XCTest

class CIDAPIURLProvidingTests: XCTestCase {

    func testFormatsURLUsingCID() {
        let cid = ConventionIdentifier(identifier: "EF25")
        let urlProviding = CIDAPIURLProviding(conventionIdentifier: cid)
        let expected = "https://app.eurofurence.org/\(cid.identifier)/api"
        let actual = urlProviding.url
        
        XCTAssertEqual(expected, actual)
    }

}
