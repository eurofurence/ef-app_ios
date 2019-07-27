import EurofurenceModel
import XCTest

class WhenPerfomingSync_WithUnsuccessfulCollaboration: XCTestCase {

    func testTheTaskEndsWithCollaborationError() {
        let stubError = NSError()
        let syncCollaboration = UnsuccessfulRefreshCollaboration(error: stubError)
        let context = EurofurenceSessionTestBuilder().with(syncCollaboration).build()
        
        context.refreshLocalStore()
        context.simulateSyncSuccess(.randomWithoutDeletions)
        
        XCTAssertEqual(.collaborationError(stubError), context.lastRefreshError)
        XCTAssertEqual(context.longRunningTaskManager.state, .ended)
    }

}
