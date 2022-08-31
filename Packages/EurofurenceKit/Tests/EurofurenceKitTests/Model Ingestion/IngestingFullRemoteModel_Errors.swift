import EurofurenceKit
import Logging
import XCTest

class IngestingFullRemoteModel_Errors: XCTestCase {

    func testIngestingRemoteResponse_RemoteFetchFailure() async throws {
        let logger = Logger(label: "Test")
        let network = FakeNetwork()
        let configuration = EurofurenceModel.Configuration(
            environment: .memory,
            network: network,
            logger: logger,
            conventionIdentifier: ConventionIdentifier("EF26")
        )
        
        let model = EurofurenceModel(configuration: configuration)
        let syncURL = try XCTUnwrap(URL(string: "https://app.eurofurence.org/EF26/api/Sync"))
        let networkError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        network.stub(url: syncURL, with: networkError)
        
        await XCTAssertEventuallyThrowsSpecificError(
            EurofurenceError.syncFailure,
            { try await model.updateLocalStore() }
        )
    }
    
    func testIngestingRemoteResponse_DifferingConventionIdentifiers() async throws {
        let logger = Logger(label: "Test")
        let network = FakeNetwork()
        let configuration = EurofurenceModel.Configuration(
            environment: .memory,
            network: network,
            logger: logger,
            conventionIdentifier: ConventionIdentifier("EF25")
        )
        
        let model = EurofurenceModel(configuration: configuration)
        
        let sampleResponse = EF26FullSyncResponseFile()
        let syncURL = try XCTUnwrap(URL(string: "https://app.eurofurence.org/EF26/api/Sync"))
        network.stub(url: syncURL, with: try sampleResponse.loadFileContents())
        
        await XCTAssertEventuallyThrowsSpecificError(
            EurofurenceError.conventionIdentifierMismatch,
            { try await model.updateLocalStore() }
        )
    }

}
