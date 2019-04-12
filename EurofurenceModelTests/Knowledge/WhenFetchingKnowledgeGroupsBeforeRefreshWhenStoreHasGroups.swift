import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFetchingKnowledgeGroupsBeforeRefreshWhenStoreHasGroups: XCTestCase {

    func testTheGroupsFromTheStoreAreAdaptedInOrder() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingKnowledgeServiceObserver()
        context.knowledgeService.add(observer)

        KnowledgeGroupAssertion().assertGroups(observer.capturedGroups,
                                               characterisedByGroup: syncResponse.knowledgeGroups.changed,
                                               entries: syncResponse.knowledgeEntries.changed)
    }

}
