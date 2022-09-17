@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class EventTests: EurofurenceKitTestCase {
    
    func testFavouritingEventMarksEventAsFavouriteWithObjectWillChangeEvent() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let dealersDenID = "18ab1606-506e-4b7c-b1db-4d3dad0e7c20"
        let dealersDen = try scenario.model.event(identifiedBy: dealersDenID)
        XCTAssertFalse(dealersDen.isFavourite, "Events should not default to be in the user's favourites")
        
        var changed = false
        let eventWillChangeSubscription = dealersDen.objectWillChange.sink { _ in
            changed = true
        }
        
        addTeardownBlock {
            eventWillChangeSubscription.cancel()
        }
        
        await dealersDen.favourite()
        
        XCTAssertTrue(dealersDen.isFavourite, "Event should be marked as favourite after actioning the favourite")
        XCTAssertTrue(changed, "Favouriting an event should trigger an update notification")
    }
    
    func testFavouritingAnAlreadyFavouritedEventDoesNotPostUpdateNotification() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let dealersDenID = "18ab1606-506e-4b7c-b1db-4d3dad0e7c20"
        let dealersDen = try scenario.model.event(identifiedBy: dealersDenID)
        XCTAssertFalse(dealersDen.isFavourite, "Events should not default to be in the user's favourites")
        
        await dealersDen.favourite()
        
        var changed = false
        let eventWillChangeSubscription = dealersDen.objectWillChange.sink { _ in
            changed = true
        }
        
        addTeardownBlock {
            eventWillChangeSubscription.cancel()
        }
        
        await dealersDen.favourite()
        
        XCTAssertFalse(
            changed,
            "Favouriting an event that is already a favourite should not post a change notification"
        )
    }

}
