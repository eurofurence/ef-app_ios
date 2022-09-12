import EurofurenceKit
import XCTAsyncAssertions
import XCTest

class FetchingRoomTests: EurofurenceKitTestCase {
    
    func testNoRoomExistsThrowsError() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let unknownRoomID = "I don't exist"
        
        XCTAssertThrowsSpecificError(
            EurofurenceError.invalidRoom(unknownRoomID),
            try scenario.model.room(identifiedBy: unknownRoomID)
        )
    }

}
