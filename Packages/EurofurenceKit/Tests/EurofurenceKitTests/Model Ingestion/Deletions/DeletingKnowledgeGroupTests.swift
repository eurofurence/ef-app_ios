@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class DeletingKnowledgeGroupTests: XCTestCase {
    
    func testDeletingKnowledgeGroupDeletesEntriesAssociatedWithGroup() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert once the knowledge group has been deleted, the models invariants continue to be satisfied *and* the
        // entries associated with the group have been deleted.
        let deletedKnowledgeGroupIdentifier = "92cdf214-7e9f-6bfa-0370-dfadd5e76493"
        let knowledgeEntryIdentifiers = try autoreleasepool { () -> [NSManagedObjectID] in
            let fetchRequest: NSFetchRequest<EurofurenceKit.KnowledgeGroup> = EurofurenceKit.KnowledgeGroup.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", deletedKnowledgeGroupIdentifier)
            fetchRequest.fetchLimit = 1
            
            let results = try scenario.viewContext.fetch(fetchRequest)
            let knowledgeGroup = try XCTUnwrap(results.first)
            
            return knowledgeGroup.entries.map(\.objectID)
        }
        
        try await scenario.updateLocalStore(using: .deletedKnowledgeGroup)
        
        for knowledgeEntryIdentifier in knowledgeEntryIdentifiers {
            XCTAssertThrowsError(try scenario.viewContext.existingObject(with: knowledgeEntryIdentifier))
        }
    }

}
