@testable import EurofurenceKit
import XCTest

class PerformingLocalStoreUpdateAfterFullSyncTests: XCTestCase {
    
    func testUsesTimestampFromLastUpdateInSyncRequest() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let lastSyncTime = Date()
        scenario.modelProperties.lastSyncTime = lastSyncTime
        
        let formattedSyncTime = EurofurenceISO8601DateFormatter.instance.string(from: lastSyncTime)
        let expectedSyncURLString = "https://app.eurofurence.org/EF26/api/Sync?since=\(formattedSyncTime)"
        let expectedSyncURL = try XCTUnwrap(URL(string: expectedSyncURLString))
        let response = EF26FullSyncResponseFile()
        scenario.stub(url: expectedSyncURL, with: .success(try response.loadFileContents()))
        try await scenario.updateLocalStore()
        
        try response.assertAgainstEntities(in: scenario.viewContext)
    }
    
    func testRecordsTimestampAfterSuccessfulSyncRequest() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let response = EF26FullSyncResponseFile()
        try await scenario.updateLocalStore(using: response)
        
        XCTAssertEqual(response.currentDate, scenario.modelProperties.lastSyncTime)
    }
    
    func testDoesNotRecordTimestampAfterUnsuccessfulSyncRequest_NetworkFailure() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let networkError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        scenario.stubSyncResponse(with: .failure(networkError))
        
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore() }
        
        XCTAssertNil(scenario.modelProperties.lastSyncTime)
    }
    
    func testDoesNotRecordTimestampAfterUnsuccessfulSyncRequest_ConventionIdentifierMismatch() async throws {
        let scenario = EurofurenceModelTestBuilder().with(conventionIdentifier: ConventionIdentifier("EF25")).build()
        
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore(using: EF26FullSyncResponseFile()) }
        
        XCTAssertNil(scenario.modelProperties.lastSyncTime)
    }
    
    func testDoesNotRecordTimestampAfterUnsuccessfulSyncRequest_ModelProcessingError() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore(using: EF26CorruptSyncResponseFile()) }
        
        XCTAssertNil(scenario.modelProperties.lastSyncTime)
    }

}
