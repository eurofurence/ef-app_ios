import EurofurenceKit
import XCTAsyncAssertions
import XCTest

@MainActor
class ProcessingFullSyncResponseTests: XCTestCase {
    
    func testCanIngestCurrentRemoteResponse() async throws {
        let modelConfiguration = EurofurenceModel.Configuration(environment: .memory, conventionIdentifier: .current)
        let model = EurofurenceModel(configuration: modelConfiguration)
        
        await XCTAssertEventuallyNoThrows { try await model.updateLocalStore() }
    }

}
