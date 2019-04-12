import EurofurenceModel
import XCTest

class KnowledgeGroupsRemoveAllBeforeInsertTests: XCTestCase {

    func testTellTheDataStoreToDeleteTheKnowledgeGroups() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.knowledgeGroups.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(subsequentResponse.knowledgeGroups.changed,
                       context.dataStore.fetchKnowledgeGroups(),
                       "Should have removed original groups between sync events")
    }

}
