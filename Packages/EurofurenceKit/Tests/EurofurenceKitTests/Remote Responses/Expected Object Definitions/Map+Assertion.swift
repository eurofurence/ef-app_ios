@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension EurofurenceWebAPI.Map {
    
    func assert(
        against actual: EurofurenceKit.Map,
        in managedObjectContext: NSManagedObjectContext,
        from response: SynchronizationPayload
    ) throws {
        XCTAssertEqual(lastChangeDateTimeUtc, actual.lastEdited)
        XCTAssertEqual(id, actual.identifier)
        XCTAssertEqual(description, actual.mapDescription)
        XCTAssertEqual(order, Int(actual.order))
        XCTAssertEqual(isBrowseable, actual.isBrowsable)
        
        let image = try XCTUnwrap(actual.graphic, "Maps must have a corresponding graphic")
        let expectedImage = try response.image(identifiedBy: imageIdentifier)
        expectedImage.assert(against: image)
        
        XCTAssertEqual(entries.count, actual.entries.count, "Entry mismatch")
        
        for entry in entries {
            let entityEntry = try XCTUnwrap(
                actual.entries.first(where: { $0.identifier == entry.id }),
                "Missing entry \(entry.id)"
            )
            
            XCTAssertEqual(entry.x, Int(entityEntry.x))
            XCTAssertEqual(entry.y, Int(entityEntry.y))
            XCTAssertEqual(entry.tapRadius, Int(entityEntry.radius))
            
            XCTAssertEqual(entry.links.count, entityEntry.links.count, "Entry links mismatch")
            
            for link in entry.links {
                // Test there exists a link with all the attributes we expect.
                let entityLinks = entityEntry.links
                let containsLink = entityLinks.contains { entityLink in
                    return entityLink.fragmentType == link.fragmentType &&
                           entityLink.target == link.target &&
                           entityLink.name == link.name
                }
                
                XCTAssertTrue(containsLink, "Map entity did not parse link")
            }
        }
    }
    
}
