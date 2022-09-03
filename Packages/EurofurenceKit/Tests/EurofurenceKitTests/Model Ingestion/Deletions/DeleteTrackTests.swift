@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class DeleteTrackTests: XCTestCase {
    
    func testDeletingTrackRemovesEventsThatArePartOfTrack() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Once the track has been deleted, any events that were part of the track should also be deleted.
        let deletedTrackIdentifier = "f23cc7f6-34c1-48d5-8acb-0ec10c353403"
        let eventIdentifiers = try autoreleasepool { () -> [NSManagedObjectID] in
            let fetchRequest: NSFetchRequest<EurofurenceKit.Track> = EurofurenceKit.Track.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", deletedTrackIdentifier)
            fetchRequest.fetchLimit = 1
            
            let results = try scenario.viewContext.fetch(fetchRequest)
            let track = try XCTUnwrap(results.first)
            
            return track.events.map(\.objectID)
        }
        
        try await scenario.updateLocalStore(using: .deletedTrack)
        
        for eventIdentifier in eventIdentifiers {
            XCTAssertThrowsError(try scenario.viewContext.existingObject(with: eventIdentifier))
        }
    }

}
