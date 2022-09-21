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
        
        let changedExpectation = expectation(description: "Expected object to notify it has changed")
        let eventWillChangeSubscription = dealersDen.objectWillChange.sink { _ in
            changedExpectation.fulfill()
        }
        
        addTeardownBlock {
            eventWillChangeSubscription.cancel()
        }
        
        await dealersDen.favourite()
        
        XCTAssertTrue(dealersDen.isFavourite, "Event should be marked as favourite after actioning the favourite")
        waitForExpectations(timeout: 0.5)
    }
    
    func testFavouritingAnAlreadyFavouritedEventDoesNotPostUpdateNotification() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let dealersDenID = "18ab1606-506e-4b7c-b1db-4d3dad0e7c20"
        let dealersDen = try scenario.model.event(identifiedBy: dealersDenID)
        await dealersDen.favourite()
        
        let changedExpectation = expectation(description: "Did not expect object to notify it has changed")
        changedExpectation.isInverted = true
        let eventWillChangeSubscription = dealersDen.objectWillChange.sink { _ in
            changedExpectation.fulfill()
        }
        
        addTeardownBlock {
            eventWillChangeSubscription.cancel()
        }
        
        await dealersDen.favourite()
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testUnfavouritingEventRemovesFavouriteMarkerAndPostsUpdateNotification() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let dealersDenID = "18ab1606-506e-4b7c-b1db-4d3dad0e7c20"
        let dealersDen = try scenario.model.event(identifiedBy: dealersDenID)
        await dealersDen.favourite()
        
        let changedExpectation = expectation(description: "Expected object to notify it has changed")
        let eventWillChangeSubscription = dealersDen.objectWillChange.sink { _ in
            changedExpectation.fulfill()
        }
        
        addTeardownBlock {
            eventWillChangeSubscription.cancel()
        }
        
        await dealersDen.unfavourite()
        
        XCTAssertFalse(dealersDen.isFavourite, "Unfavouriting an event should not maintain the favourite marker")
        waitForExpectations(timeout: 0.5)
    }
    
    func testUnfavouritingEventThatIsNotFavouritedDoesNotPostUpdateNotification() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let dealersDenID = "18ab1606-506e-4b7c-b1db-4d3dad0e7c20"
        let dealersDen = try scenario.model.event(identifiedBy: dealersDenID)
        
        let changedExpectation = expectation(description: "Did not expect object to notify it has changed")
        changedExpectation.isInverted = true
        let eventWillChangeSubscription = dealersDen.objectWillChange.sink { _ in
            changedExpectation.fulfill()
        }
        
        addTeardownBlock {
            eventWillChangeSubscription.cancel()
        }
        
        await dealersDen.unfavourite()
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testContentURL() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let dealersDenID = "18ab1606-506e-4b7c-b1db-4d3dad0e7c20"
        let dealersDen = try scenario.model.event(identifiedBy: dealersDenID)
        
        let expected = try XCTUnwrap(URL(string: "https://stubbed.for.test"))
        await scenario.api.stub(expected, forContent: .event(id: dealersDenID))
        
        let actual = dealersDen.contentURL
        
        XCTAssertEqual(expected, actual)
    }

}
