import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class AfterIngestingRemoteModel_ImageFetchingTests: EurofurenceKitTestCase {
    
    func testRequestsImagesFromAPI() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // We would expect to see exactly one request per image identifier. Each image should be downloaded to the
        // known location in the file system, identified by their ID.
        let expectedImageRequests = payload.images.changed.map { image -> APIRequests.DownloadImage in
            let expectedDownloadURL = scenario.modelProperties.proposedURL(forImageIdentifier: image.id)
            return APIRequests.DownloadImage(
                imageIdentifier: image.id,
                lastKnownImageContentHashSHA1: image.contentHashSha1,
                downloadDestinationURL: expectedDownloadURL
            )
        }
        
        let requestedImages = scenario.api.executedRequests(ofType: APIRequests.DownloadImage.self)
        XCTAssertEqual(expectedImageRequests.count, requestedImages.count)
        XCTAssertEqual(Set(expectedImageRequests), Set(requestedImages))
    }
    
    func testFailingToFetchSomeImagesDoesNotAbandonTheEntireLoad() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        
        // Given a portion of the downloads fail, we expect to still attempt all download requests and not abandon
        // the process prematurely.
        let numberOfImages = payload.images.changed.count
        let halfNumberOfImages = numberOfImages / 2
        let imagesToFailDownloading = payload.images.changed.prefix(halfNumberOfImages)
        
        for image in imagesToFailDownloading {
            struct SomeError: Error { }
            
            let expectedRequest = APIRequests.DownloadImage(
                imageIdentifier: image.id,
                lastKnownImageContentHashSHA1: image.contentHashSha1,
                downloadDestinationURL: scenario.modelProperties.proposedURL(forImageIdentifier: image.id)
            )
            
            scenario.api.stub(request: expectedRequest, with: .failure(SomeError()))
        }
        
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        let expectedImageRequests = payload.images.changed.map { image -> APIRequests.DownloadImage in
            let expectedDownloadURL = scenario.modelProperties.proposedURL(forImageIdentifier: image.id)
            return APIRequests.DownloadImage(
                imageIdentifier: image.id,
                lastKnownImageContentHashSHA1: image.contentHashSha1,
                downloadDestinationURL: expectedDownloadURL
            )
        }
        
        let requestedImages = scenario.api.executedRequests(ofType: APIRequests.DownloadImage.self)
        XCTAssertEqual(expectedImageRequests.count, requestedImages.count)
        XCTAssertEqual(Set(expectedImageRequests), Set(requestedImages))
    }
    
    func testSuccessfullyDownloadingImageUpdatesEntityWithURL() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
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
            
            let expectedURL = scenario.modelProperties.proposedURL(forImageIdentifier: image.id)
            XCTAssertEqual(expectedURL, entity.cachedImageURL)
        }
    }
    
    func testFailingToDownloadImageDoesNotUpdateEntityWithURL() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        
        // We'll fail to download the image for an announcement, then assert the associated entity does not contain
        // a URL.
        let firstAnnouncement = try XCTUnwrap(payload.announcements.changed.first)
        let announcementImageIdentifier = try XCTUnwrap(firstAnnouncement.imageIdentifier)
        
        let networkError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        try await stubDownload(
            result: .failure(networkError),
            forImageIdentifiedBy: announcementImageIdentifier,
            in: payload,
            scenario: scenario
        )
        
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
    
    func testPreviouslyFailedImageRequestIsReattemptedOnNextSync() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        
        // We'll fail to download the image for an announcement, then on the next attempt succeed. We should then see
        // the corresponding image entity contain the local URL.
        let firstAnnouncement = try XCTUnwrap(payload.announcements.changed.first)
        let announcementImageIdentifier = try XCTUnwrap(firstAnnouncement.imageIdentifier)
        
        let networkError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        try await stubDownload(
            result: .failure(networkError),
            forImageIdentifiedBy: announcementImageIdentifier,
            in: payload,
            scenario: scenario
        )
        
        await scenario.stubSyncResponse(with: .success(payload))
        
        try await scenario.updateLocalStore()
        
        try await stubDownload(
            result: .success(()),
            forImageIdentifiedBy: announcementImageIdentifier,
            in: payload,
            scenario: scenario
        )
        
        let noChanges = try SampleResponse.noChanges.loadResponse()
        await scenario.stubSyncResponse(with: .success(noChanges), for: payload.synchronizationToken)
        try await scenario.updateLocalStore()
        
        let announcement: EurofurenceKit.Announcement = try scenario.viewContext.entity(
            withIdentifier: firstAnnouncement.id
        )
        
        let announcementImage = try XCTUnwrap(announcement.image)
        let expectedURL = scenario.modelProperties.proposedURL(forImageIdentifier: announcementImageIdentifier)
        
        XCTAssertEqual(expectedURL, announcementImage.cachedImageURL)
    }
    
    private func stubDownload(
        result: Result<Void, Error>,
        forImageIdentifiedBy identifier: String,
        in payload: SynchronizationPayload,
        scenario: EurofurenceModelTestBuilder.Scenario
    ) async throws {
        let image = try XCTUnwrap(payload.images.changed.first(where: { $0.id == identifier }))
        
        let expectedRequest = APIRequests.DownloadImage(
            imageIdentifier: image.id,
            lastKnownImageContentHashSHA1: image.contentHashSha1,
            downloadDestinationURL: scenario.modelProperties.proposedURL(forImageIdentifier: image.id)
        )
        
        scenario.api.stub(request: expectedRequest, with: result)
    }

}
