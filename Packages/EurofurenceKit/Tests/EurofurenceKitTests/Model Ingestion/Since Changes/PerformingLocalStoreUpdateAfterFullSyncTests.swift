@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class PerformingLocalStoreUpdateAfterFullSyncTests: XCTestCase {
    
    func testUsesTimestampFromLastUpdateInSyncRequest() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let changeToken = SynchronizationPayload.GenerationToken(lastSyncTime: Date())
        scenario.modelProperties.synchronizationChangeToken = changeToken
        try await scenario.updateLocalStore(using: .ef26)
        
        let lastChangeToken = await scenario.api.lastChangeToken
        XCTAssertEqual(changeToken, lastChangeToken)
    }
    
    func testRecordsTimestampAfterSuccessfulSyncRequest() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let response = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(response))
        try await scenario.updateLocalStore()
        let expected = response.synchronizationToken
        
        XCTAssertEqual(expected, scenario.modelProperties.synchronizationChangeToken)
    }
    
    func testDoesNotRecordTimestampAfterUnsuccessfulSyncRequest_NetworkFailure() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let networkError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        await scenario.stubSyncResponse(with: .failure(networkError))
        
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore() }
        
        XCTAssertNil(scenario.modelProperties.synchronizationChangeToken)
    }
    
    func testDoesNotRecordTimestampAfterUnsuccessfulSyncRequest_ConventionIdentifierMismatch() async throws {
        let scenario = await EurofurenceModelTestBuilder().with(conventionIdentifier: ConventionIdentifier("EF25")).build()
        
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore(using: .ef26) }
        
        XCTAssertNil(scenario.modelProperties.synchronizationChangeToken)
    }
    
    func testDoesNotRecordTimestampAfterUnsuccessfulSyncRequest_ModelProcessingError() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.corruptEF26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        
        await XCTAssertEventuallyThrowsError { try await scenario.updateLocalStore() }
        
        XCTAssertNil(scenario.modelProperties.synchronizationChangeToken)
    }

}
