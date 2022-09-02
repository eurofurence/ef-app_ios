import EurofurenceWebAPI
import XCTest

class AfterIngestingRemoteModel_ImageFetchingTests: XCTestCase {
    
    func testRequestsImagesFromAPI() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // We would expect to see exactly one request per image identifier. Each image should be downloaded to the
        // known location in the file system, identified by their ID.
        let expectedImagesURL = scenario.modelProperties.containerDirectoryURL.appendingPathComponent("Images")
        let expectedImageRequests = payload.images.changed.map { image -> DownloadImageRequest in
            let expectedDownloadURL = expectedImagesURL.appendingPathComponent(image.id)
            return DownloadImageRequest(
                imageIdentifier: image.id,
                lastKnownImageContentHashSHA1: image.contentHashSha1,
                downloadDestinationURL: expectedDownloadURL
            )
        }
        
        XCTAssertEqual(expectedImageRequests.count, scenario.api.requestedImages.count)
        XCTAssertEqual(Set(expectedImageRequests), Set(scenario.api.requestedImages))
    }

}
