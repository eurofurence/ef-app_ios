import EurofurenceModel
import TestUtilities
import XCTest
import XCTEurofurenceModel

class ImageAPITests: XCTestCase {

    func testSubmitsExpectedURL() throws {
        let identifier = String.random
        let hash = String.random
        let apiUrl = StubAPIURLProviding()
        let urlString = "\(apiUrl.url)Images/\(identifier)/Content/with-hash:\(hash)"
        let expected = try XCTUnwrap(URL(string: urlString)).absoluteString
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
