import EurofurenceKit
import XCTest

class IngestingFullRemoteModel_Errors: XCTestCase {

    func testIngestingRemoteResponse_RemoteFetchFailure() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let networkError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        scenario.stubSyncResponse(with: .failure(networkError))
        
        await XCTAssertEventuallyThrowsSpecificError(
            EurofurenceError.syncFailure,
            { try await scenario.updateLocalStore() }
        )
    }
    
    func testIngestingRemoteResponse_DifferingConventionIdentifiers() async throws {
        let scenario = EurofurenceModelTestBuilder().with(conventionIdentifier: ConventionIdentifier("EF25")).build()
        
        await XCTAssertEventuallyThrowsSpecificError(
            EurofurenceError.conventionIdentifierMismatch,
            { try await scenario.updateLocalStore(using: .ef26) }
        )
    }

}
