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
    
    func testContentsAtPoint_ExactMatch() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // Dealers Den
        let map = try scenario.model.map(identifiedBy: "62a74341-880f-49f1-a52d-0a3f480e81a6")
        
        // Animas Animus
        let point = Map.Coordinate(x: 427, y: 1080)
        let item = try XCTUnwrap(map.entry(at: point), "Expected to find an entry at the exact position")
        
        if case .dealer(let dealer) = item {
            XCTAssertEqual("895d60b9-1462-4d35-91c5-113ab5aba47c", dealer.id, "Expected Animal Animus")
        } else {
            XCTFail("Unexpected map element: \(item)")
        }
    }
    
    func testContentsAtPoint_OutsideOfToleranceOnHorizontalAxis() async throws {
        
    }
    
    func testContentsAtPoint_OutsideOfToleranceOnVerticalAxis() async throws {
        
    }
    
    func testContentsAtPoint_OutsideOfToleranceOnBothAxis() async throws {
        
    }
    
    func testContentsAtPoint_InsideTolerance() async throws {
        
    }

}
