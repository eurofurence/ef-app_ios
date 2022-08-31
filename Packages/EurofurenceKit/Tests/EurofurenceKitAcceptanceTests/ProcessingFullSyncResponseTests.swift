import EurofurenceKit
import XCTest

class ProcessingFullSyncResponseTests: XCTestCase {
    
    func testCanIngestCurrentRemoteResponse() async throws {
        let modelConfiguration = EurofurenceModel.Configuration(environment: .memory, conventionIdentifier: .current)
        let model = EurofurenceModel(configuration: modelConfiguration)
        
        await XCTAssertEventuallyNoThrow { try await model.updateLocalStore() }
    }

}
