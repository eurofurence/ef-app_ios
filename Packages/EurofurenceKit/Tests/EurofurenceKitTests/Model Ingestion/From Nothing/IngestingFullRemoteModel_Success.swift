import EurofurenceWebAPI
import XCTest

class IngestingFullRemoteModel_Success: XCTestCase {
    
    func testIngestingRemoteResponse_InjectResponseObject() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        let assertion = SynchronizedStoreAssertion(managedObjectContext: scenario.viewContext, synchronizationPayload: payload)
        try assertion.assert()
    }
    
}
