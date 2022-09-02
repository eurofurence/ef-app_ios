import EurofurenceWebAPI
import XCTest

class AfterIngestingRemoteModel_ImageFetchingTests: XCTestCase {
    
    func testRequestsImagesFromAPI() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // We would expect to see exactly one request per image identifier.
        let expectedImageRequests = payload.images.changed.map { image in
            ImageFetchRequest(imageIdentifier: image.id, lastKnownImageContentHashSHA1: image.contentHashSha1)
        }
        
        XCTAssertEqual(expectedImageRequests.count, scenario.api.requestedImages.count)
        XCTAssertEqual(Set(expectedImageRequests), Set(scenario.api.requestedImages))
    }

}
