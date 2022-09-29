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
        let item = try XCTUnwrap(map.entries(at: point).first, "Expected to find an entry at the exact position")
        
        if case .dealer(let dealer) = item {
            XCTAssertEqual("895d60b9-1462-4d35-91c5-113ab5aba47c", dealer.id, "Expected Animal Animus")
        } else {
            XCTFail("Unexpected map element: \(item)")
        }
    }
    
    func testContentsAtPoint_OutsideOfToleranceOnHorizontalAxis() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // Dealers Den
        let map = try scenario.model.map(identifiedBy: "62a74341-880f-49f1-a52d-0a3f480e81a6")
        
        // Animas Animus has an x position of 427, and a tap radius of 70
        let point = Map.Coordinate(x: 427 - 71, y: 1080)
        XCTAssertEqual([], map.entries(at: point), "Did not expect to find an entry outside of its tap radius")
    }
    
    func testContentsAtPoint_OutsideOfToleranceOnBothAxis() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // Dealers Den
        let map = try scenario.model.map(identifiedBy: "62a74341-880f-49f1-a52d-0a3f480e81a6")
        
        // Animas Animus has an x position of 427, a y position of 1080, and a tap radius of 70.
        let point = Map.Coordinate(x: 427 - 71, y: 1080 - 71)
        XCTAssertEqual([], map.entries(at: point), "Did not expect to find an entry outside of its tap radius")
    }
    
    func testContentsAtPoint_InsideTolerance() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // Dealers Den
        let map = try scenario.model.map(identifiedBy: "62a74341-880f-49f1-a52d-0a3f480e81a6")
        
        // Animas Animus has an x position of 427, a y position of 1080, and a tap radius of 70.
        // Offsetting both by a small amount should yield the dealer.
        let point = Map.Coordinate(x: 427 - 15, y: 1080 - 15)
        let item = try XCTUnwrap(map.entries(at: point).first, "Expected to find an entry at the exact position")
        
        if case .dealer(let dealer) = item {
            XCTAssertEqual("895d60b9-1462-4d35-91c5-113ab5aba47c", dealer.id, "Expected Animal Animus")
        } else {
            XCTFail("Unexpected map element: \(item)")
        }
    }
    
    func testContentsAtPoint_MultipleDealers() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // Dealers Den
        let map = try scenario.model.map(identifiedBy: "62a74341-880f-49f1-a52d-0a3f480e81a6")
        
        let point = Map.Coordinate(x: 1500, y: 825)
        let items = map.entries(at: point)
        
        XCTAssertEqual(2, items.count, "Expected two dealers within the tap radius")
        
        var witnessedDealers = [String]()
        for item in items {
            if case .dealer(let dealer) = item {
                witnessedDealers.append(dealer.id)
            } else {
                XCTFail("Unexpected map element: \(item)")
            }
        }
        
        let emilyCreative = "78275022-12d3-4675-8227-f59e9628952e"
        let oktaviasCreatures = "717bfb01-a912-499d-9bc5-32ac3c449e98"
        
        let expectedDealersInAlphabeticalOrder = [
            emilyCreative,
            oktaviasCreatures
        ]
        
        XCTAssertEqual(
            expectedDealersInAlphabeticalOrder,
            witnessedDealers,
            "Expected to see all dealers in the tap radius, in alphabetical order"
        )
    }

}
