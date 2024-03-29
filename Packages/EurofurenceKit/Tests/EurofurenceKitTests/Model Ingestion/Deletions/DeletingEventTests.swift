import CoreData
import EurofurenceKit
import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class DeletingEventTests: EurofurenceKitTestCase {
    
    func testDeletedEventRemovedFromStore_NoImages() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert the corresponding event exists, then is deleted following the next ingestion.
        let eventIdentifier = "76430fe0-ece7-48c9-b8e6-fdbc3974ff64"
        XCTAssertNoThrow(try scenario.model.event(identifiedBy: eventIdentifier))
        
        let deleteEventPayload = try SampleResponse.deletedEvent.loadResponse()
        await scenario.stubSyncResponse(with: .success(deleteEventPayload), for: payload.synchronizationToken)
        try await scenario.updateLocalStore()
        
        XCTAssertThrowsSpecificError(
            EurofurenceError.invalidEvent(eventIdentifier),
            try scenario.model.event(identifiedBy: eventIdentifier)
        )
    }
    
    func testDeletedEventRemovedFromStore_HasBanner() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert the corresponding event exists, then is deleted following the next ingestion.
        let eventIdentifier = "d7676a70-bc1e-4fde-9891-8060cb9f291a"
        XCTAssertNoThrow(try scenario.model.event(identifiedBy: eventIdentifier))
        
        let deleteEventWithBannerPayload = try SampleResponse.deletedEventWithBanner.loadResponse()
        await scenario.stubSyncResponse(with: .success(deleteEventWithBannerPayload), for: payload.synchronizationToken)
        try await scenario.updateLocalStore()
        
        XCTAssertThrowsSpecificError(
            EurofurenceError.invalidEvent(eventIdentifier),
            try scenario.model.event(identifiedBy: eventIdentifier)
        )
    }
    
    func testDeletedEventRemovedFromStore_HasPoster() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert the corresponding event exists, then is deleted following the next ingestion.
        let eventIdentifier = "46c59831-012e-4e4b-8e15-a6de1aca3ad4"
        XCTAssertNoThrow(try scenario.model.event(identifiedBy: eventIdentifier))
        
        let deleteEventWithPosterPayload = try SampleResponse.deletedEventWithPoster.loadResponse()
        await scenario.stubSyncResponse(with: .success(deleteEventWithPosterPayload), for: payload.synchronizationToken)
        try await scenario.updateLocalStore()
        
        XCTAssertThrowsSpecificError(
            EurofurenceError.invalidEvent(eventIdentifier),
            try scenario.model.event(identifiedBy: eventIdentifier)
        )
    }
    
    func testDeletedEventRemovedFromStore_MultipleEventsSharePoster() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert the corresponding event exists, then is deleted following the next ingestion.
        // The poster should remain as it's still used by other events.
        let deletedEventIdentifier = "4a90c95f-dac0-4ca0-9f6d-a7839845ba36"
        let eventSharingPosterIdentifier = "46c59831-012e-4e4b-8e15-a6de1aca3ad4"
        XCTAssertNoThrow(try scenario.model.event(identifiedBy: deletedEventIdentifier))
        
        let deleteEventWithSharedPosterPayload = try SampleResponse.deletedEventWithSharedPoster.loadResponse()
        await scenario.stubSyncResponse(
            with: .success(deleteEventWithSharedPosterPayload),
            for: payload.synchronizationToken
        )
        
        try await scenario.updateLocalStore()
        
        XCTAssertThrowsSpecificError(
            EurofurenceError.invalidEvent(deletedEventIdentifier),
            try scenario.model.event(identifiedBy: deletedEventIdentifier)
        )
        
        let sharedPosterEvent = try scenario.model.event(identifiedBy: eventSharingPosterIdentifier)
        XCTAssertNotNil(
            sharedPosterEvent.poster,
            "Deleting an event with a poster shared amongst multiple events should not delete the poster"
        )
    }
    
    func testDeletingAllEventsForGivenPanelHostDeletesPanelHost() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // We'll delete all events hosted by "Birdy the Scottish Gryphon" (nothing personal, they only had one event!).
        // Following this, the panel host should no longer reside in the persistent store.
        let deleteBirdyEventPayload = try SampleResponse.deletedEventHostedByBirdy.loadResponse()
        await scenario.stubSyncResponse(with: .success(deleteBirdyEventPayload), for: payload.synchronizationToken)
        try await scenario.updateLocalStore()
        
        let birdyFetchRequest: NSFetchRequest<NSFetchRequestResult> = PanelHost.fetchRequest()
        birdyFetchRequest.predicate = NSPredicate(format: "name == \"Birdy the Scottish Gryphon\"")
        birdyFetchRequest.fetchLimit = 1
        birdyFetchRequest.resultType = .countResultType
        
        let count = try scenario.viewContext.count(for: birdyFetchRequest)
        XCTAssertEqual(
            0,
            count,
            "Expected the PanelHost entity to be removed when it is no longer associated with any event"
        )
    }

}
