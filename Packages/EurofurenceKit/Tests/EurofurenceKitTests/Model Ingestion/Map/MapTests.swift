import EurofurenceKit
import XCTAsyncAssertions
import XCTest

class MapTests: EurofurenceKitTestCase {
    
    func testFetchingKnownMap() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // Dealers Den
        let map = try scenario.model.map(identifiedBy: "62a74341-880f-49f1-a52d-0a3f480e81a6")
        XCTAssertEqual(map.id, "62a74341-880f-49f1-a52d-0a3f480e81a6")
    }
    
    func testFetchingUnknownMap() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        XCTAssertThrowsSpecificError(
            EurofurenceError.invalidMap("Unknown"),
            try scenario.model.map(identifiedBy: "Unknown")
        )
    }

}
