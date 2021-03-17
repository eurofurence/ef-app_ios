import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenMakingContentURL_KnowledgeEntryShould: XCTestCase {

    func testPrepareShareableURL() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let knowledgeEntry = characteristics.knowledgeEntries.changed.randomElement().element
        let dataStore = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let identifier = KnowledgeEntryIdentifier(knowledgeEntry.identifier)
        var entity: KnowledgeEntry?
        context.knowledgeService.fetchKnowledgeEntry(for: identifier, completionHandler: { entity = $0 })
        let url = entity?.contentURL
        
        XCTAssertEqual(URL(string: "knowledgeentry://\(identifier.rawValue)").unsafelyUnwrapped, url)
    }

}
