import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class DeletingRoomTests: EurofurenceKitTestCase {
    
    func testDeletingRoomRemovesEventsOccurringInRoom() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Once the room has been deleted, any events that were taking place in it should also be deleted.
        let deletedRoomIdentifier = "2d5d9a98-aaca-4434-959d-99d20e675d3a"
        let eventIdentifiers = try autoreleasepool { () -> [String] in
            let fetchRequest: NSFetchRequest<EurofurenceKit.Room> = EurofurenceKit.Room.fetchRequestForExistingEntity(
                identifier: deletedRoomIdentifier
            )
            
            let results = try scenario.viewContext.fetch(fetchRequest)
            let room = try XCTUnwrap(results.first)
            
            return room.events.map(\.identifier)
        }
        
        let deleteRoomPayload = try SampleResponse.deletedRoom.loadResponse()
        await scenario.stubSyncResponse(with: .success(deleteRoomPayload), for: payload.synchronizationToken)
        try await scenario.updateLocalStore()
        
        for eventIdentifier in eventIdentifiers {
            XCTAssertThrowsError(try scenario.model.event(identifiedBy: eventIdentifier))
        }
    }

}
