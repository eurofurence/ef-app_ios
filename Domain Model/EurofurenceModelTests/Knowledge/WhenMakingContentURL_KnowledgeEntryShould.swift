import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenMakingContentURL_KnowledgeEntryShould: XCTestCase {

    func testPrepareShareableURL() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let knowledgeEntry = characteristics.knowledgeEntries.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let identifier = KnowledgeEntryIdentifier(knowledgeEntry.identifier)
        var entity: KnowledgeEntry?
        context.knowledgeService.fetchKnowledgeEntry(for: identifier, completionHandler: { entity = $0 })
        let url = entity?.makeContentURL()
        
        XCTAssertEqual(unwrap(URL(string: "knowledgeentry://\(identifier.rawValue)")), url)
    }

}
