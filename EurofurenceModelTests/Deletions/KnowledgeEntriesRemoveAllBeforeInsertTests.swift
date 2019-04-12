import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class KnowledgeEntriesRemoveAllBeforeInsertTests: XCTestCase {

    func testTellTheDataStoreToDeleteTheKnowledgeEntries() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.knowledgeEntries.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(subsequentResponse.knowledgeEntries.changed,
                       context.dataStore.fetchKnowledgeEntries(),
                      "Should have removed original knowledge entries between sync events")
    }

}
