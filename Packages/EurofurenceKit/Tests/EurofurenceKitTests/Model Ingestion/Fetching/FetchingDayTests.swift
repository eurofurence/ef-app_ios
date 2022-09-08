import EurofurenceKit
import XCTAsyncAssertions
import XCTest

class FetchingDayTests: EurofurenceKitTestCase {
    
    func testNoDayExistsThrowsError() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let unknownDayID = "I don't exist"
        
        XCTAssertThrowsSpecificError(
            EurofurenceError.invalidDay(unknownDayID),
            try scenario.model.day(identifiedBy: unknownDayID)
        )
    }

}
