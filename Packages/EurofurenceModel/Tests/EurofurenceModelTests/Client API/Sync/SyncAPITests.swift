import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class SyncAPITests: XCTestCase {

    func testTheSyncEndpointShouldReceieveRequest() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let syncApi = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let url = apiUrl.url + "Sync"
        syncApi.fetchLatestData(lastSyncTime: nil) { (_) in }

        XCTAssertEqual(url, jsonSession.getRequestURL)
    }

    func testInvalidResponseEmitsNilResult() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let syncApi = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let invalidResponseData = "{not json!".data(using: .utf8)
        var providedWithNilResponse = false
        syncApi.fetchLatestData(lastSyncTime: nil) { providedWithNilResponse = $0 == nil }
        jsonSession.invokeLastGETCompletionHandler(responseData: invalidResponseData)

        XCTAssertTrue(providedWithNilResponse)
    }

    func testSuccessfulResponseDoesNotEmitNilResponse() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let syncApi = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let responseData = EurofurenceModelTestAssets.successfulSyncResponseData

        var wasProvidedWithNilResponse = false
        syncApi.fetchLatestData(lastSyncTime: nil) { wasProvidedWithNilResponse = $0 == nil }
        jsonSession.invokeLastGETCompletionHandler(responseData: responseData)

        XCTAssertFalse(wasProvidedWithNilResponse)
    }

    func testFailedNetworkResponseEmitsNilResult() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let syncApi = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        var providedWithNilResponse = false
        syncApi.fetchLatestData(lastSyncTime: nil) { providedWithNilResponse = $0 == nil }
        jsonSession.invokeLastGETCompletionHandler(responseData: nil)

        XCTAssertTrue(providedWithNilResponse)
    }

    func testSupplyingLastSyncTimeSuppliesSinceParameter() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let syncApi = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let lastSyncTime = Date.random
        syncApi.fetchLatestData(lastSyncTime: lastSyncTime) { (_) in }
        let expectedSinceTime = Iso8601DateFormatter.instance.string(from: lastSyncTime)
        let expected = apiUrl.url.appending("Sync?since=\(expectedSinceTime)")
        let actual = jsonSession.getRequestURL

        XCTAssertEqual(expected, actual)
    }
    
    func testPassingURLWithoutTrailingSlashFormatsURLCorrectly_BUG() {
        let jsonSession = CapturingJSONSession()
        let urlWithoutTrailingSlash = "https://some.domain/api"
        let apiUrl = StubAPIURLProviding(url: urlWithoutTrailingSlash)
        let syncApi = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        syncApi.fetchLatestData(lastSyncTime: nil) { (_) in }
        let expected = "\(urlWithoutTrailingSlash)/Sync"
        let actual = jsonSession.getRequestURL
        
        XCTAssertEqual(expected, actual)
    }

}
