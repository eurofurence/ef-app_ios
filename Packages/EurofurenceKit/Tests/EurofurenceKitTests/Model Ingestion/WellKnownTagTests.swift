import CoreData
@testable import EurofurenceKit
import XCTest

class WellKnownTagTests: XCTestCase {
    
    func testSponsorOnly() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let eventWithTag = try self.eventWithTag(named: "sponsors_only", in: scenario.viewContext)
        
        XCTAssertTrue(eventWithTag.canonicalTags.contains(.sponsorOnly))
    }
    
    func testSuperSponsorOnly() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let eventWithTag = try self.eventWithTag(named: "supersponsors_only", in: scenario.viewContext)
        
        XCTAssertTrue(eventWithTag.canonicalTags.contains(.superSponsorOnly))
    }
    
    func testArtShow() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let eventWithTag = try self.eventWithTag(named: "art_show", in: scenario.viewContext)
        
        XCTAssertTrue(eventWithTag.canonicalTags.contains(.artShow))
    }
    
    func testKage() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let eventWithTag = try self.eventWithTag(named: "kage", in: scenario.viewContext)
        
        XCTAssertTrue(eventWithTag.canonicalTags.contains(.kage))
    }
    
    func testDealersDen() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let eventWithTag = try self.eventWithTag(named: "dealers_den", in: scenario.viewContext)
        
        XCTAssertTrue(eventWithTag.canonicalTags.contains(.dealersDen))
    }
    
    func testMainStage() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let eventWithTag = try self.eventWithTag(named: "main_stage", in: scenario.viewContext)
        
        XCTAssertTrue(eventWithTag.canonicalTags.contains(.mainStage))
    }
    
    func testPhotoshoot() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let eventWithTag = try self.eventWithTag(named: "photoshoot", in: scenario.viewContext)
        
        XCTAssertTrue(eventWithTag.canonicalTags.contains(.photoshoot))
    }
    
    func testFaceMaskRequired() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let eventWithTag = try self.eventWithTag(named: "mask_required", in: scenario.viewContext)
        
        XCTAssertTrue(eventWithTag.canonicalTags.contains(.faceMaskRequired))
    }
    
    private func eventWithTag(named name: String, in managedObjectContext: NSManagedObjectContext) throws -> Event {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "SELF.tags.name CONTAINS %@", name)
        fetchRequest.fetchLimit = 1
        
        let matches = try managedObjectContext.fetch(fetchRequest)
        let eventWithTag = try XCTUnwrap(matches.first)
        
        return eventWithTag
    }

}
