import EurofurenceModel
import EurofurenceModelTestDoubles
import TestUtilities
import XCTest

class ImageAPITests: XCTestCase {

    func testSubmitsExpectedURL() {
        let identifier = String.random
        let hash = String.random
        let apiUrl = StubAPIURLProviding()
        let expected = URL(string: apiUrl.url + "Images/\(identifier)/Content/with-hash:\(hash)").unsafelyUnwrapped.absoluteString
        let jsonSession = CapturingJSONSession()
        let api = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        api.fetchImage(identifier: identifier, contentHashSha1: hash) { (_) in }

        XCTAssertEqual(expected, jsonSession.getRequestURL)
    }

    func testProvidesDataFromRequest() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let api = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let expected = Data.random
        var actual: Data?
        api.fetchImage(identifier: .random, contentHashSha1: "") { actual = $0 }
        jsonSession.invokeLastGETCompletionHandler(responseData: expected)

        XCTAssertEqual(expected, actual)
    }

}
