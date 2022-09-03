@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class DeleteDayTests: XCTestCase {
    
    func testDeletingDatRemovesEventsThatOccurOnIt() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Once the track has been deleted, any events that were part of the track should also be deleted.
        let deletedDayIdentifier = "db6e0b07-3300-4d58-adfd-84c145e36242"
        let eventIdentifiers = try autoreleasepool { () -> [NSManagedObjectID] in
            let fetchRequest: NSFetchRequest<EurofurenceKit.Day> = EurofurenceKit.Day.fetchRequestForExistingEntity(
                identifier: deletedDayIdentifier
            )
            
            let results = try scenario.viewContext.fetch(fetchRequest)
            let day = try XCTUnwrap(results.first)
            
            return day.events.map(\.objectID)
        }
        
        try await scenario.updateLocalStore(using: .deletedDay)
        
        for eventIdentifier in eventIdentifiers {
            XCTAssertThrowsError(try scenario.viewContext.existingObject(with: eventIdentifier))
        }
    }

}
