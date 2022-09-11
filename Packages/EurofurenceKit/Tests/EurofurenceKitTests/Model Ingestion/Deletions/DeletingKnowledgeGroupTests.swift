import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class DeletingKnowledgeGroupTests: EurofurenceKitTestCase {
    
    func testDeletingKnowledgeGroupDeletesEntriesAssociatedWithGroup() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let payload = try SampleResponse.ef26.loadResponse()
        await scenario.stubSyncResponse(with: .success(payload))
        try await scenario.updateLocalStore()
        
        // Assert once the knowledge group has been deleted, the models invariants continue to be satisfied *and* the
        // entries associated with the group have been deleted.
        let deletedKnowledgeGroupIdentifier = "92cdf214-7e9f-6bfa-0370-dfadd5e76493"
        let knowledgeEntryIdentifiers = try autoreleasepool { () -> [String] in
            let fetchRequest: NSFetchRequest<EurofurenceKit.KnowledgeGroup> = EurofurenceKit
                .KnowledgeGroup
                .fetchRequestForExistingEntity(identifier: deletedKnowledgeGroupIdentifier)
            
            let results = try scenario.viewContext.fetch(fetchRequest)
            let knowledgeGroup = try XCTUnwrap(results.first)
            
            return knowledgeGroup.orderedKnowledgeEntries.map(\.identifier)
        }
        
        // Ensure each knowledge entry is available before processing the deletion
        for knowledgeEntryIdentifier in knowledgeEntryIdentifiers {
            XCTAssertNoThrow(try scenario.model.knowledgeEntry(identifiedBy: knowledgeEntryIdentifier))
        }
        
        try await scenario.updateLocalStore(using: .deletedKnowledgeGroup)
        
        for knowledgeEntryIdentifier in knowledgeEntryIdentifiers {
            XCTAssertThrowsSpecificError(
                EurofurenceError.invalidKnowledgeEntry(knowledgeEntryIdentifier),
                try scenario.model.knowledgeEntry(identifiedBy: knowledgeEntryIdentifier)
            )
        }
    }

}
