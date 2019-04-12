import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDeletingKnowledgeGroup_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testTellTheStoreToDeleteTheGroup() {
        let dataStore = FakeDataStore()
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let groupToDelete = response.knowledgeGroups.changed.remove(at: 0)
        response.knowledgeGroups.deleted = [groupToDelete.identifier]
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)

        XCTAssertEqual(false, dataStore.fetchKnowledgeGroups()?.contains(groupToDelete))
    }

}
