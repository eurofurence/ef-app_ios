@testable import EurofurenceKit
import XCTest

class PerformingLocalStoreUpdateAfterFullSyncTests: XCTestCase {
    
    func testUsesTimestampFromLastUpdateInSyncRequest() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let lastSyncTime = Date()
        scenario.modelProperties.lastSyncTime = lastSyncTime
        try await scenario.updateLocalStore(using: EF26FullSyncResponseFile())
        
        XCTAssertEqual(lastSyncTime, scenario.api.lastSyncTime)
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
