@testable import EurofurenceKit
import Foundation
import XCTest

struct ExpectedKnowledgeEntry {
    
    var lastUpdated: Date
    var identifier: String
    var knowledgeGroupIdentifier: String
    var title: String
    var text: String
    var order: Int
    var links: [ExpectedKnowledgeEntryLink]
    var imageIdentifiers: [String]
    
    init(
        lastUpdated: String,
        identifier: String,
        knowledgeGroupIdentifier: String,
        title: String,
        text: String,
        order: Int,
        links: [ExpectedKnowledgeEntryLink],
        imageIdentifiers: [String]
    ) {
        let dateFormatter = EurofurenceISO8601DateFormatter.instance
        self.lastUpdated = dateFormatter.date(from: lastUpdated)!
        self.identifier = identifier
        self.knowledgeGroupIdentifier = knowledgeGroupIdentifier
        self.title = title
        self.text = text
        self.order = order
        self.links = links
        self.imageIdentifiers = imageIdentifiers
    }
    
    func assert<R>(
        against actual: KnowledgeEntry,
        in managedObjectContext: NSManagedObjectContext,
        from response: R
    ) throws where R: SyncResponseFile {
        XCTAssertEqual(lastUpdated, actual.lastEdited)
        XCTAssertEqual(identifier, actual.identifier)
        XCTAssertEqual(title, actual.title)
        XCTAssertEqual(text, actual.text)
        XCTAssertEqual(order, Int(actual.order))
        
        let knowledgeGroup: KnowledgeGroup = try managedObjectContext.entity(withIdentifier: knowledgeGroupIdentifier)
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

class ExpectedLink {
    
    var fragmentType: String
    var name: String
    var target: String
    
    init(
        fragmentType: String,
        name: String,
        target: String
    ) {
        self.fragmentType = fragmentType
        self.name = name
        self.target = target
    }
    
}

class ExpectedKnowledgeEntryLink: ExpectedLink {
    
    var knowledgeEntryIdentifier: String
    
    init(fragmentType: String, name: String, target: String, knowledgeEntryIdentifier: String) {
        self.knowledgeEntryIdentifier = knowledgeEntryIdentifier
        super.init(fragmentType: fragmentType, name: name, target: target)
    }
    
}
