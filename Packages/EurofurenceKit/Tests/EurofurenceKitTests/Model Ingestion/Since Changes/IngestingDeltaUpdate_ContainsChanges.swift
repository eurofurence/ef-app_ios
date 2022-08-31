import XCTest

class IngestingDeltaUpdate_ContainsChanges: XCTestCase {
    
    func testChangedEntitiesAreNotReinserted_SameResponseTwice() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let response = EF26FullSyncResponseFile()
        try await scenario.updateLocalStore(using: response)
        
        // For each type of expected entity, there should remain a single instance of the entity within the persistent
        // store.
        
        await XCTAssertEventuallyNoThrows { try await scenario.updateLocalStore(using: response) }
        try response.assertAgainstEntities(in: scenario.viewContext)
    }

}
