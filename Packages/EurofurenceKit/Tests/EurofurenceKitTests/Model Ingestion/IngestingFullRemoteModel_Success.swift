import XCTest

class IngestingFullRemoteModel_Success: XCTestCase {
    
    func testIngestingRemoteResponse() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let response = EF26FullSyncResponseFile()
        try await scenario.updateLocalStore(using: response)
        
        let managedObjectContext = scenario.viewContext
        try scenario.viewContext.performAndWait { [managedObjectContext] in
            try response.assertAgainstEntities(in: managedObjectContext)
        }
    }
    
}
