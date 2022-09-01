import EurofurenceWebAPI
import XCTest

class IngestingFullRemoteModel_Success: XCTestCase {
    
    func testIngestingRemoteResponse() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let response = EF26FullSyncResponseFile()
        try await scenario.updateLocalStore(using: response)
        
        try response.assertAgainstEntities(in: scenario.viewContext)
    }
    
    func testIngestingRemoteResponse_InjectResponseObject() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let response = EF26FullSyncResponseFile()
        let responseData = try response.loadFileContents()
        let decoder = EurofurenceAPIDecoder()
        let payload = try decoder.decodeSynchronizationPayload(from: responseData)
        scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        let assertion = SyncResponseAssertion2(managedObjectContext: scenario.viewContext, synchronizationPayload: payload)
        try assertion.assert()
    }
    
}
