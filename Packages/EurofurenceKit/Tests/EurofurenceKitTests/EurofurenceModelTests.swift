@testable import EurofurenceKit
import Logging
import XCTest

class EurofurenceKitTests: XCTestCase {
    
    func testIngestingRemoteResponse() async throws {
        let logger = Logger(label: "Test")
        let network = FakeNetwork()
        let configuration = EurofurenceModel.Configuration(environment: .memory, logger: logger)
        let model = EurofurenceModel(configuration: configuration)
        
        let sampleResponse = EF26FullSyncResponseFile()
        let syncURL = try XCTUnwrap(URL(string: "https://app.eurofurence.org/EF26/api/Sync"))
        network.stub(url: syncURL, with: try sampleResponse.loadFileContents())
        await model.updateLocalStore()
        
        try sampleResponse.assertAgainstEntities(in: model.viewContext)
    }
    
}
