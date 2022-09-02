import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class DeletingEventTests: XCTestCase {
    
    func testDeletedEventRemovedFromStore_NoImages() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert the corresponding event exists, then is deleted following the next ingestion.
        let eventIdentifier = "76430fe0-ece7-48c9-b8e6-fdbc3974ff64"
        XCTAssertNoThrow(try scenario.model.event(identifiedBy: eventIdentifier))
        
        try await scenario.updateLocalStore(using: .deletedEvent)
        
        XCTAssertThrowsSpecificError(EurofurenceError.invalidEvent(eventIdentifier)) {
            _ = try scenario.model.event(identifiedBy: eventIdentifier)
        }
    }
    
    func testDeletedEventRemovedFromStore_HasBanner() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert the corresponding event exists, then is deleted following the next ingestion.
        let eventIdentifier = "d7676a70-bc1e-4fde-9891-8060cb9f291a"
        XCTAssertNoThrow(try scenario.model.event(identifiedBy: eventIdentifier))
        
        try await scenario.updateLocalStore(using: .deletedEventWithBanner)
        
        XCTAssertThrowsSpecificError(EurofurenceError.invalidEvent(eventIdentifier)) {
            _ = try scenario.model.event(identifiedBy: eventIdentifier)
        }
    }
    
    func testDeletedEventRemovedFromStore_HasPoster() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert the corresponding event exists, then is deleted following the next ingestion.
        let eventIdentifier = "46c59831-012e-4e4b-8e15-a6de1aca3ad4"
        XCTAssertNoThrow(try scenario.model.event(identifiedBy: eventIdentifier))
        
        try await scenario.updateLocalStore(using: .deletedEventWithPoster)
        
        XCTAssertThrowsSpecificError(EurofurenceError.invalidEvent(eventIdentifier)) {
            _ = try scenario.model.event(identifiedBy: eventIdentifier)
        }
    }
    
    func testDeletedEventRemovedFromStore_MultipleEventsSharePoster() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert the corresponding event exists, then is deleted following the next ingestion.
        // The poster should remain as it's still used by other events.
        let deletedEventIdentifier = "4a90c95f-dac0-4ca0-9f6d-a7839845ba36"
        let eventSharingPosterIdentifier = "46c59831-012e-4e4b-8e15-a6de1aca3ad4"
        XCTAssertNoThrow(try scenario.model.event(identifiedBy: deletedEventIdentifier))
        
        try await scenario.updateLocalStore(using: .deletedEventWithSharedPoster)
        
        XCTAssertThrowsSpecificError(EurofurenceError.invalidEvent(deletedEventIdentifier)) {
            _ = try scenario.model.event(identifiedBy: deletedEventIdentifier)
        }
        
        let sharedPosterEvent = try scenario.model.event(identifiedBy: eventSharingPosterIdentifier)
        XCTAssertNotNil(
            sharedPosterEvent.poster,
            "Deleting an event with a poster shared amongst multiple events should not delete the poster"
        )
    }

}
