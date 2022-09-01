@testable import EurofurenceWebAPI
import XCTest

class CIDSensitiveEurofurenceAPITests: XCTestCase {
    
    func testSyncWithoutTimestampUsesExpectedURL() async throws {
        let network = FakeNetwork()
        let expectedURL = try XCTUnwrap(URL(string: "https://app.eurofurence.org/EF26/api/Sync"))
        let responseFileURL = try XCTUnwrap(Bundle.module.url(forResource: "EF26FullSyncResponse", withExtension: "json"))
        let responseFileData = try Data(contentsOf: responseFileURL)
        network.stub(url: expectedURL, with: .success(responseFileData))
        let api = CIDSensitiveEurofurenceAPI(network: network)
        _ = try await api.executeSyncRequest(lastUpdateTime: nil)
        
        let expected = FakeNetwork.Event.get(url: expectedURL)
        XCTAssertEqual([expected], network.history)
    }
    
    func testSyncWithTimestampUsesExpectedURL() async throws {
        let network = FakeNetwork()
        let lastSyncTime = Date()
        let formattedSyncTime = EurofurenceISO8601DateFormatter.instance.string(from: lastSyncTime)
        let expectedURL = try XCTUnwrap(URL(string: "https://app.eurofurence.org/EF26/api/Sync?since=\(formattedSyncTime)"))
        let responseFileURL = try XCTUnwrap(Bundle.module.url(forResource: "EF26FullSyncResponse", withExtension: "json"))
        let responseFileData = try Data(contentsOf: responseFileURL)
        network.stub(url: expectedURL, with: .success(responseFileData))
        let api = CIDSensitiveEurofurenceAPI(network: network)
        _ = try await api.executeSyncRequest(lastUpdateTime: lastSyncTime)
        
        let expected = FakeNetwork.Event.get(url: expectedURL)
        XCTAssertEqual([expected], network.history)
    }

}
