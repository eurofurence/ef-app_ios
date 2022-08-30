@testable import EurofurenceKit
import Logging
import XCTest

func XCTAssertEventuallyThrowsSpecificError<E>(
    _ expected: E,
    _ block: () async throws -> Void,
    file: StaticString = #file,
    line: UInt = #line
) async where E: Error & Equatable {
    do {
        try await block()
        XCTFail("Expected to throw an error.", file: file, line: line)
    } catch let error as E {
        XCTAssertEqual(expected, error, file: file, line: line)
    } catch {
        XCTFail("Unexpected error thrown: \(error)", file: file, line: line)
    }
}

class EurofurenceKitTests: XCTestCase {
    
    func testIngestingRemoteResponse() async throws {
        let logger = Logger(label: "Test")
        let network = FakeNetwork()
        let configuration = EurofurenceModel.Configuration(
            environment: .memory,
            network: network,
            logger: logger,
            conventionIdentifier: ConventionIdentifier("EF26")
        )
        
        let model = EurofurenceModel(configuration: configuration)
        
        let sampleResponse = EF26FullSyncResponseFile()
        let syncURL = try XCTUnwrap(URL(string: "https://app.eurofurence.org/EF26/api/Sync"))
        network.stub(url: syncURL, with: try sampleResponse.loadFileContents())
        try await model.updateLocalStore()
        
        try sampleResponse.assertAgainstEntities(in: model.viewContext)
    }
    
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
