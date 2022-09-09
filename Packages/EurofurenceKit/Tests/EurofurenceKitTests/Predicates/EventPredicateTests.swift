import CoreData
@testable import EurofurenceKit
import XCTest

class EventPredicateTests: EurofurenceKitTestCase {
    
    func testEventsInDayPredicateOnlyMatchesEventsOccurringOnDay() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let earlyArrivalIdentifier = "db6e0b07-3300-4d58-adfd-84c145e36242"
        let earlyArrivalEventIdentifier = "76430fe0-ece7-48c9-b8e6-fdbc3974ff64"
        let someOtherEventIdentifier = "c54cb9f1-602b-47b4-849c-6c448a909cd1"
        
        let earlyArrival = try scenario.model.day(identifiedBy: earlyArrivalIdentifier)
        let earlyArrivalEvent = try scenario.model.event(identifiedBy: earlyArrivalEventIdentifier)
        let someOtherEvent = try scenario.model.event(identifiedBy: someOtherEventIdentifier)
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = Event.predicate(forEventsOccurringOn: earlyArrival)
        
        let matches = try scenario.viewContext.fetch(fetchRequest)
        
        XCTAssertTrue(matches.contains(earlyArrivalEvent))
        XCTAssertFalse(matches.contains(someOtherEvent))
    }
    
    func testEventsOnTrackPredicateOnlyMatchesEventsOnTrack() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let artShowTrackIdentifier = "f23cc7f6-34c1-48d5-8acb-0ec10c353403"
        let artShowSetupAndCheckInIdentifier = "06d8a4bd-6211-463c-9737-4b87588c0ab0"
        let fursuitBadgePickUpAndPrintingIdentifier = "f43e6808-b8ed-43a3-8836-ad9493b53d11"
        
        let artShowTrack = try scenario.model.track(identifiedBy: artShowTrackIdentifier)
        let artShowSetup = try scenario.model.event(identifiedBy: artShowSetupAndCheckInIdentifier)
        let fursuitBadgePickUpAndPrinting = try scenario.model.event(identifiedBy: fursuitBadgePickUpAndPrintingIdentifier)
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = Event.predicate(forEventsInTrack: artShowTrack)
        
        let matches = try scenario.viewContext.fetch(fetchRequest)
        
        XCTAssertTrue(matches.contains(artShowSetup))
        XCTAssertFalse(matches.contains(fursuitBadgePickUpAndPrinting))
    }
    
    func testEventSearchPredicateReturnsMatchingEventsWhereTitleIsExactlyTheSame() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // Cheese & Wine
        let cheeseAndWineEventIdentifier = "073fc7b1-8165-413c-b028-db802c360bcf"
        let cheeseAndWine = try scenario.model.event(identifiedBy: cheeseAndWineEventIdentifier)
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = Event.predicateForTextualSearch(query: "Cheese & Wine")
        
        let matches = try scenario.viewContext.fetch(fetchRequest)
        
        XCTAssertEqual(1, matches.count, "Expected only one match for query")
        
        let match = try XCTUnwrap(matches.first)
        
        XCTAssertEqual(cheeseAndWine, match)
    }
    
    func testEventSearchPredicateReturnsMatchingEventsWhereTitleIsSameWithDifferentCase() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // Cheese & Wine
        let cheeseAndWineEventIdentifier = "073fc7b1-8165-413c-b028-db802c360bcf"
        let cheeseAndWine = try scenario.model.event(identifiedBy: cheeseAndWineEventIdentifier)
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = Event.predicateForTextualSearch(query: "cheese & wine")
        
        let matches = try scenario.viewContext.fetch(fetchRequest)
        
        XCTAssertEqual(1, matches.count, "Expected only one match for query")
        
        let match = try XCTUnwrap(matches.first)
        
        XCTAssertEqual(cheeseAndWine, match)
    }
    
    func testEventSearchPredicateReturnsMatchingEventsWhereQueryIsSubstring() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // Cheese & Wine
        let cheeseAndWineEventIdentifier = "073fc7b1-8165-413c-b028-db802c360bcf"
        let cheeseAndWine = try scenario.model.event(identifiedBy: cheeseAndWineEventIdentifier)
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = Event.predicateForTextualSearch(query: "cheese")
        
        let matches = try scenario.viewContext.fetch(fetchRequest)
        
        XCTAssertEqual(1, matches.count, "Expected only one match for query")
        
        let match = try XCTUnwrap(matches.first)
        
        XCTAssertEqual(cheeseAndWine, match)
    }

}
