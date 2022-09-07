import CoreData
@testable import EurofurenceKit
import XCTest

class WellKnownDealerCategoryTests: XCTestCase {
    
    func testPrints() async throws {
        try await assertCategory(named: "Prints", hasCanonicalCategory: .prints)
    }
    
    func testFursuits() async throws {
        try await assertCategory(named: "Fursuits", hasCanonicalCategory: .fursuits)
    }
    
    func testCommissions() async throws {
        try await assertCategory(named: "Commissions", hasCanonicalCategory: .commissions)
    }
    
    func testArtwork() async throws {
        try await assertCategory(named: "Artwork", hasCanonicalCategory: .artwork)
    }
    
    func testMiscellaneous() async throws {
        try await assertCategory(named: "Miscellaneous", hasCanonicalCategory: .miscellaneous)
    }
    
    private func assertCategory(
        named name: String,
        hasCanonicalCategory expected: CanonicalDealerCategory,
        line: UInt = #line
    ) async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let category = try self.category(named: name, in: scenario.viewContext)
        
        XCTAssertEqual(category.canonicalCategory, expected, line: line)
    }
    
    private func category(named name: String, in managedObjectContext: NSManagedObjectContext) throws -> DealerCategory {
        let fetchRequest: NSFetchRequest<DealerCategory> = DealerCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        
        let matches = try managedObjectContext.fetch(fetchRequest)
        return try XCTUnwrap(matches.first)
    }

}
