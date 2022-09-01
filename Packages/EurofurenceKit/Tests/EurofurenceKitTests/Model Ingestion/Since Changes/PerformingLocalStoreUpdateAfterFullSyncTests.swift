@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class PerformingLocalStoreUpdateAfterFullSyncTests: XCTestCase {
    
    func testUsesTimestampFromLastUpdateInSyncRequest() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let changeToken = SynchronizationPayload.GenerationToken(lastSyncTime: Date())
        scenario.modelProperties.synchronizationChangeToken = changeToken
        try await scenario.updateLocalStore(using: EF26FullSyncResponseFile())
        
        XCTAssertEqual(changeToken, scenario.api.lastChangeToken)
    }
    
    func testRecordsTimestampAfterSuccessfulSyncRequest() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let response = EF26FullSyncResponseFile()
        try await scenario.updateLocalStore(using: response)
        let expected = SynchronizationPayload.GenerationToken(lastSyncTime: response.currentDate)
        
        XCTAssertEqual(expected, scenario.modelProperties.synchronizationChangeToken)
    }
    
    func testDoesNotRecordTimestampAfterUnsuccessfulSyncRequest_NetworkFailure() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let networkError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        scenario.stubSyncResponse(with: .failure(networkError))
        
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore() }
        
        XCTAssertNil(scenario.modelProperties.synchronizationChangeToken)
    }
    
    func testDoesNotRecordTimestampAfterUnsuccessfulSyncRequest_ConventionIdentifierMismatch() async throws {
        let scenario = EurofurenceModelTestBuilder().with(conventionIdentifier: ConventionIdentifier("EF25")).build()
        
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore(using: EF26FullSyncResponseFile()) }
        
        XCTAssertNil(scenario.modelProperties.synchronizationChangeToken)
    }
    
    func testDoesNotRecordTimestampAfterUnsuccessfulSyncRequest_ModelProcessingError() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore(using: EF26CorruptSyncResponseFile()) }
        
        XCTAssertNil(scenario.modelProperties.synchronizationChangeToken)
    }

}
