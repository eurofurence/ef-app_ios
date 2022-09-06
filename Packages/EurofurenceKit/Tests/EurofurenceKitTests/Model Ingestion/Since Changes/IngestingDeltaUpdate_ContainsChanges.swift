import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class IngestingDeltaUpdate_ContainsChanges: XCTestCase {
    
    func testChangedEntitiesAreNotReinserted_SameResponseTwice() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // For each type of expected entity, there should remain a single instance of the entity within the persistent
        // store.
        
        await XCTAssertEventuallyNoThrows { try await scenario.updateLocalStore() }
        let assertion = SynchronizedStoreAssertion(
            managedObjectContext: scenario.viewContext,
            synchronizationPayload: payload
        )
        
        try assertion.assert()
    }

}
