import EurofurenceKit
import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class DeletingAnnouncementTests: XCTestCase {
    
    func testDeletedAnnouncementRemovedFromStore() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert the corresponding announcement exists, then is deleted following the next ingestion.
        let announcementIdentifier = "8822b105-a46c-441a-a8db-cd6c084d33c8"
        XCTAssertNoThrow(try scenario.model.announcement(identifiedBy: announcementIdentifier))
        
        try await scenario.updateLocalStore(using: .deletedAnnouncement)
        
        XCTAssertThrowsSpecificError(EurofurenceError.invalidAnnouncement(announcementIdentifier)) {
            _ = try scenario.model.announcement(identifiedBy: announcementIdentifier)
        }
    }

}
