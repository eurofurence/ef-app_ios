import EurofurenceWebAPI
@testable import EurofurenceKit
import XCTest

class AfterIngestingRemoteModel_ImageFetchingTests: XCTestCase {
    
    func testRequestsImagesFromAPI() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // We would expect to see exactly one request per image identifier. Each image should be downloaded to the
        // known location in the file system, identified by their ID.
        let expectedImagesURL = scenario.modelProperties.imagesDirectory
        let expectedImageRequests = payload.images.changed.map { image -> DownloadImageRequest in
            let expectedDownloadURL = expectedImagesURL.appendingPathComponent(image.id)
            return DownloadImageRequest(
                imageIdentifier: image.id,
                lastKnownImageContentHashSHA1: image.contentHashSha1,
                downloadDestinationURL: expectedDownloadURL
            )
        }
        
        let requestedImages: [DownloadImageRequest] = await scenario.api.requestedImages
        XCTAssertEqual(expectedImageRequests.count, requestedImages.count)
        XCTAssertEqual(Set(expectedImageRequests), Set(requestedImages))
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
            await scenario.api.stub(.failure(SomeError()), forImageIdentifier: identifier)
        }
        
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        let expectedImagesURL = scenario.modelProperties.imagesDirectory
        let expectedImageRequests = payload.images.changed.map { image -> DownloadImageRequest in
            let expectedDownloadURL = expectedImagesURL.appendingPathComponent(image.id)
            return DownloadImageRequest(
                imageIdentifier: image.id,
                lastKnownImageContentHashSHA1: image.contentHashSha1,
                downloadDestinationURL: expectedDownloadURL
            )
        }
        
        let requestedImages: [DownloadImageRequest] = await scenario.api.requestedImages
        XCTAssertEqual(expectedImageRequests.count, requestedImages.count)
        XCTAssertEqual(Set(expectedImageRequests), Set(requestedImages))
    }
    
    func testSuccessfullyDownloadingImageUpdatesEntityWithURL() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // All the images were downloaded successfully. Each image entity should now contain a URL designating where
        // the image data lives within the container.
        for image in payload.images.changed {
            let fetchRequest: NSFetchRequest<EurofurenceKit.Image> = EurofurenceKit.Image.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", image.id)
            fetchRequest.fetchLimit = 1
            
            let results = try scenario.viewContext.fetch(fetchRequest)
            guard let entity = results.first else { continue }
            
            let expectedURL = scenario.modelProperties.imagesDirectory.appendingPathComponent(image.id)
            XCTAssertEqual(expectedURL, entity.cachedImageURL)
        }
    }
    
    func testFailingToDownloadImageDoesNotUpdateEntityWithURL() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        
        // We'll fail to download the image for an announcement, then assert the associated entity does not contain
        // a URL.
        let firstAnnouncement = try XCTUnwrap(payload.announcements.changed.first)
        let announcementImageIdentifier = try XCTUnwrap(firstAnnouncement.imageIdentifier)
        
        let networkError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        await scenario.api.stub(.failure(networkError), forImageIdentifier: announcementImageIdentifier)
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        let announcement: EurofurenceKit.Announcement = try scenario.viewContext.entity(
            withIdentifier: firstAnnouncement.id
        )
        
        let announcementImage = try XCTUnwrap(announcement.image)
        XCTAssertNil(
            announcementImage.cachedImageURL,
            "Failed to download image - image should not contain a local URL"
        )
    }

}
