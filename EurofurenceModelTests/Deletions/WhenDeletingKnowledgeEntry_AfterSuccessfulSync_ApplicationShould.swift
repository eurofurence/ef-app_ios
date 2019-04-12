import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDeletingKnowledgeEntry_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testTellTheStoreToDeleteTheEntry() {
        let dataStore = FakeDataStore()
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let entryToDelete = response.knowledgeEntries.changed.remove(at: 0)
        response.knowledgeEntries.deleted = [entryToDelete.identifier]
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let entries = dataStore.fetchKnowledgeEntries()

        XCTAssertEqual(false, entries?.contains(entryToDelete))
    }

}
