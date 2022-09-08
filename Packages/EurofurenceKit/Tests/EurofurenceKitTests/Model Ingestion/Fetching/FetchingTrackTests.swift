import EurofurenceKit
import XCTAsyncAssertions
import XCTest

class FetchingTrackTests: EurofurenceKitTestCase {
    
    func testNoTrackExistsThrowsError() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let unknownTrackID = "I don't exist"
        
        XCTAssertThrowsSpecificError(
            EurofurenceError.invalidTrack(unknownTrackID), 
            try scenario.model.track(identifiedBy: unknownTrackID)
        )
    }

}
