import CoreData
@testable import EurofurenceKit
import XCTest

class KnowledgeEntryImagePredicateTests: EurofurenceKitTestCase {

    func testImagesForEntryPredicateOnlyMatchesImagesForEntry() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let howCanYouHelpEntryIdentifier = "d54a7222-777c-4f97-4f79-64848169d448"
        let howCanYouHelpImageIdentifier = "5605b5dd-4270-48b3-b5c1-842c878ec807"
        let paramedicsImageIdentifier = "2ffe3196-6eba-439c-8153-be15baeb2eb6"
        
        let glympseEntry = try scenario.model.knowledgeEntry(identifiedBy: howCanYouHelpEntryIdentifier)
        
        let fetchRequest: NSFetchRequest<KnowledgeEntryImage> = KnowledgeEntryImage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", howCanYouHelpImageIdentifier)
        let glympseImage = try XCTUnwrap(try scenario.viewContext.fetch(fetchRequest).first)
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", paramedicsImageIdentifier)
        let paramedicsImage = try XCTUnwrap(try scenario.viewContext.fetch(fetchRequest).first)
        
        let predicate = KnowledgeEntryImage.predicateForImages(in: glympseEntry)
        fetchRequest.predicate = predicate
        
        let results = try scenario.viewContext.fetch(fetchRequest)
        
        XCTAssertTrue(results.contains(glympseImage))
        XCTAssertFalse(results.contains(paramedicsImage))
    }

}
