import CoreData
@testable import EurofurenceKit
import XCTest

class KnowledgeEntryTests: EurofurenceKitTestCase {
    
    func testImagesRetainOrderFromResponse() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let summerboatKnowledgeEntryIdentifier = "816a7298-0bda-4769-9982-260faa76cd59"
        let summerboatEntry = try scenario.model.knowledgeEntry(identifiedBy: summerboatKnowledgeEntryIdentifier)
        
        let expectedImageOrder: [String] = [
            "3b9d4776-4ffc-4d56-8cb2-103aec41a904"
        ]
        
        let actualImageOrder = summerboatEntry.orderedImages.map(\.identifier)
        
        XCTAssertEqual(expectedImageOrder, actualImageOrder, "Images should retain their order")
    }
    
    func testLinksRetainOrderFromResponse() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let infoTechTeamKnowledgeEntryIdentifier = "b815c24d-dfe1-0736-ae78-3047c53362b2"
        let infoTechTeamEntry = try scenario.model.knowledgeEntry(identifiedBy: infoTechTeamKnowledgeEntryIdentifier)
        
        let expectedNameOrder: [String?] = [
            "@ZefiroDragon",
            "it@eurofurence.org"
        ]
        
        let actualNameOrder = infoTechTeamEntry.orderedLinks.map(\.name)
        
        XCTAssertEqual(expectedNameOrder, actualNameOrder, "Links should remain in a consistent order")
    }

}
