import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension EurofurenceWebAPI.KnowledgeEntry {
    
    func assert(
        against actual: EurofurenceKit.KnowledgeEntry,
        in managedObjectContext: NSManagedObjectContext,
        from response: SynchronizationPayload
    ) throws {
        XCTAssertEqual(lastChangeDateTimeUtc, actual.lastEdited)
        XCTAssertEqual(id, actual.identifier)
        XCTAssertEqual(title, actual.title)
        XCTAssertEqual(text, actual.text)
        XCTAssertEqual(order, Int(actual.order))
        
        let knowledgeGroup: EurofurenceKit.KnowledgeGroup = try managedObjectContext.entity(withIdentifier: knowledgeGroupIdentifier)
        XCTAssertEqual(knowledgeGroup, actual.group)
        
        XCTAssertEqual(links.count, actual.links.count)
        
        for link in links {
            let actualLink = try XCTUnwrap(actual.links.first(where: { $0.target == link.target }))
            XCTAssertEqual(link.fragmentType, actualLink.fragmentType)
            XCTAssertEqual(link.name, actualLink.name)
        }
        
        XCTAssertEqual(imageIdentifiers.count, actual.images.count)
        
        for imageIdentifier in imageIdentifiers {
            let expectedImage = try response.image(identifiedBy: imageIdentifier)
            let image: KnowledgeEntryImage = try managedObjectContext.entity(withIdentifier: imageIdentifier)
            expectedImage.assert(against: image)
            XCTAssertTrue(actual.images.contains(image))
        }
    }
    
}
