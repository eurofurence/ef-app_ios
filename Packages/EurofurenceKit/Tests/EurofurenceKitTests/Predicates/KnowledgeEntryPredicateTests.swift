import CoreData
@testable import EurofurenceKit
import XCTest

class KnowledgeEntryPredicateTests: EurofurenceKitTestCase {

    func testEntriesInGroupPredicateOnlyMatchesEntriesInGroup() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let aboutEurofurenceGroupIdentifier = "92cdf214-7e9f-6bfa-0370-dfadd5e76493"
        let websiteTeamEntryIdentifier = "920a440f-112b-b851-dff8-653af3c040d8"
        let glympseEntryIdentifier = "329ac21a-6acd-bea1-5d18-3cd34bb03e54"
        
        let aboutEurofurenceGroup = try scenario.model.knowledgeGroup(identifiedBy: aboutEurofurenceGroupIdentifier)
        let websiteTeamEntry = try scenario.model.knowledgeEntry(identifiedBy: websiteTeamEntryIdentifier)
        let glympseEntry = try scenario.model.knowledgeEntry(identifiedBy: glympseEntryIdentifier)
        
        let fetchRequest: NSFetchRequest<KnowledgeEntry> = KnowledgeEntry.fetchRequest()
        fetchRequest.predicate = KnowledgeEntry.predicateForEntries(in: aboutEurofurenceGroup)
        
        let matches = try scenario.viewContext.fetch(fetchRequest)
        
        XCTAssertTrue(matches.contains(websiteTeamEntry))
        XCTAssertFalse(matches.contains(glympseEntry))
    }

}
