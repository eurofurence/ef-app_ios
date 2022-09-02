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
    
    func testFailingToFetchSomeImagesDoesNotAbandonTheEntireLoad() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        
        // Given a portion of the downloads fail, we expect to still attempt all download requests and not abandon
        // the process prematurely.
        let numberOfImages = payload.images.changed.count
        let halfNumberOfImages = numberOfImages / 2
        let requestIdentifiersToFail = payload.images.changed.map(\.id).prefix(halfNumberOfImages)
        
        for identifier in requestIdentifiersToFail {
            struct SomeError: Error { }
            scenario.api.stub(.failure(SomeError()), forImageIdentifier: identifier)
        }
        
        scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
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
