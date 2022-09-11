import EurofurenceWebAPI
import XCTest

class IngestingFullRemoteModel_Success: EurofurenceKitTestCase {
    
    func testIngestingRemoteResponse_InjectResponseObject() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        let assertion = SynchronizedStoreAssertion(
            managedObjectContext: scenario.viewContext,
            synchronizationPayload: payload
        )
        
        try assertion.assert()
    }
    
}
